{-# LANGUAGE DeriveFunctor, DeriveTraversable, GeneralizedNewtypeDeriving, RecordWildCards, DeriveGeneric, LambdaCase, NoImplicitPrelude, OverloadedStrings, NamedFieldPuns, TupleSections #-}

module Main where

import Protolude hiding (sym, retry)
import qualified Text.Show as Show
import Control.Monad.Catch (Handler(..))
import qualified Data.HashMap.Strict as HM
import qualified Data.HashMap.Strict.InsOrd as HMIO
import qualified Data.Sequence as Seq
import Data.Either.Validation

import qualified Data.Text as T

import qualified Dhall as D
import qualified Dhall.Core as DC
import Dhall.Parser (Src)
import qualified Dhall.Parser
import qualified Dhall.Import
import Dhall.TypeCheck (X)
import qualified Dhall.TypeCheck

import qualified Data.Text.Prettyprint.Doc as Pretty
import qualified Data.Text.Prettyprint.Doc.Render.Text as PrettyText

import qualified Control.Concurrent.Async.Pool as Async
import Control.Retry (RetryStatus(..), recovering, exponentialBackoff)

import qualified Data.Aeson as Aeson
import qualified Data.Aeson.Encode.Pretty as AesonPretty
import qualified Foreign.Nix.Shellout.Prefetch as P
import GHC.Generics (Generic)


-- Dhall library code

-- | Package name.
newtype PName = PName { unPName :: D.Text }
  deriving (Show, Eq, Hashable, Aeson.ToJSONKey)
-- | HashMap with package names as keys.
type PMap a = HM.HashMap PName a
-- | InsOrdHashMap with package names as keys.
type PMapIO a = HMIO.InsOrdHashMap PName a

-- | Spacchetthi packages cannot be read.
data CompileError
 = WrongPackageTypes (PMapIO ())
   -- ^ a package has the wrong type
 | ToplevelNotSet (DC.Expr X X)
   -- ^ the toplevel value is not a set
 deriving (Typeable)

instance Show CompileError where
  show err = toS $ T.intercalate "\n" $
    [ _ERROR <> ": Cannot parse package set"
    , "" ]
    <> msg err

    where
      msg :: CompileError -> [D.Text]
      msg (WrongPackageTypes ts) =
        [ "Explanation: The outermost record must only contain packages."
        , ""
        , "The following fields where not packages:"
        , ""
        , "↳ " <> DC.pretty
            (listLit $ fmap (textLit . unPName)
                     $ HMIO.keys ts :: DC.Expr X X)
        ]
      msg (ToplevelNotSet tl) =
        [ "Explanation: The outermost value must be a record of packages."
        , ""
        , "The record was:"
        , ""
        , "↳ " <> pretty tl
        ]

pretty :: Pretty.Pretty a => DC.Expr s a -> D.Text
pretty = PrettyText.renderStrict
        . Pretty.layoutPretty Pretty.defaultLayoutOptions
        . Pretty.pretty

textLit :: D.Text -> DC.Expr s a
textLit = DC.TextLit . DC.Chunks []

listLit :: [(DC.Expr s a)] -> DC.Expr s a
listLit = DC.ListLit Nothing . Seq.fromList

instance Exception CompileError

_ERROR :: D.Text
_ERROR = "\ESC[1;31mError\ESC[0m"

-- | A spacchetti package.
data Package = Package
  { dependencies :: [Text]
    -- ^ list of dependency package names
  , repo :: Text
    -- ^ the git repository
  , version :: Text }
    -- ^ version string (also functions as a git ref)
  deriving (Show, Generic)

-- | Takes a map of Dhall record fields and tries to parse
-- them as packages. That is it type-checks and normalizes
-- each field and accumulates errors.
packages :: PMapIO (DC.Expr Src X)
         -> Validation
             (PMapIO (Dhall.TypeCheck.TypeError Src X))
             (PMapIO Package)
packages = HMIO.traverseWithKey (\k e -> toVal k $ toPkg k e)
  where
    toVal name = either (Failure . HMIO.singleton name) Success
    toPkg :: PName -> DC.Expr Src X
          -> Either (Dhall.TypeCheck.TypeError Src X) Package
    toPkg (PName name) pkgExpr = do
      let pkgType = D.genericAuto :: D.Type Package
      -- we annotate the expression with the type we want,
      -- then typeOf will check the type for us
      -- TODO: do we have to test if there is an annotation already?
      let eAnnot = DC.Annot pkgExpr
                   $ D.expected pkgType
      -- typeOf only returns the type, which we already know
      _ <- Dhall.TypeCheck.typeOf eAnnot
      -- the normalize is not strictly needed (we already normalized
      -- the expressions that were given to this function)
      -- but it converts the @DC.Expr s a@ @s@ arguments to any @t@,
      -- which is needed for @extract@ to type check with @eAnnot@
      case D.extract pkgType $ DC.normalize $ eAnnot of
        Just x -> pure x
        Nothing -> DC.internalError
          $ "packages: " <> toS name <> " has an InvalidType\n"
          <> toS (pretty (DC.denote eAnnot :: DC.Expr X X))


-- Fetching of repositories

parallelTasks, numberOfRetries, retryBaseDelayMs :: Int
-- | Number of repositories to fetch at the same time.
parallelTasks = 5
-- | Number of times to retry fetching a repository.
numberOfRetries = 5
-- | Base delay between retries, increases with @n^2@.
retryBaseDelayMs = 500

-- | Exception that is thrown when a fetch fails.
newtype Err = Err (P.NixActionError P.PrefetchError)
  deriving (Show)

instance Exception Err

-- | Fetch all given packages, and always a pool of 'parallelTasks'
-- packages at the same time.
--
-- Takes a 'Chan' that recieves a message when a fetch is starting,
-- with information about the package and the number of retries.
--
-- Returns a Map of package name to hashes, or throws 'Err' if a
-- fetch failed even after some retries.
fetchAllParallel :: Chan (PName, RetryStatus)
                 -- ^ messages package name that is currently fetched
                 -> PMap Package
                 -> IO (PMap P.Sha256)
fetchAllParallel chan pkgs = Async.withTaskGroup parallelTasks
  $ \taskGroup -> do
      job <- atomically $ Async.mapReduce taskGroup actions
      fetched <- Async.wait job
      pure $ HM.fromList fetched
  where
    -- ATTN: if the retry fails, it throws an exception.
    -- I hate that, but otherwise Async.Pool just continues. :(
    -- Update: even with an Exception, it also continues. TODO
    -- | Construct a list of package fetch actions that
    -- each are retried a few times, with exponential backoff.
    actions :: [IO [(PName, P.Sha256)]]
    actions = flip map (HM.toList pkgs) $ \pkg -> do
      a <- recovering
        (exponentialBackoff retryBaseDelayMs)
        [should]
        (action pkg)
      pure [a]

    -- | Whether a fetch should be retried.
    should :: RetryStatus -> Handler IO Bool
    should RetryStatus{rsIterNumber} = Handler
          $ \(Err _) -> pure $ rsIterNumber < numberOfRetries

    -- | One fetch.
    action :: (PName, Package)
           -> RetryStatus
           -> IO (PName, P.Sha256)
    action (name, Package{repo, version}) rs = do
      liftIO $ writeChan chan (name, rs)
      let opt = (P.defaultGitOptions $ P.Url repo)
                  { P.gitRev = Just version }
      eith <- P.runNixAction $ P.gitOutputSha256
          <$> P.git opt
      case eith of
        Left err -> throwIO $ Err err
        Right sha -> pure $ (name, sha)


-- Main

-- | Path to the file to read.
packagesDhall :: Text
packagesDhall = "./src/packages.dhall"

main :: IO ()
main = do
  expr  <- throws (Dhall.Parser.exprFromText mempty packagesDhall)
  expr' <- Dhall.Import.load expr
  go $ DC.normalize expr'
  where
    go :: DC.Expr Src X -> IO ()
    go = \case

      -- reads the outermost record into and calls everything
      (DC.RecordLit hm) ->
        case packages $ HMIO.mapKeys PName hm of
        Failure errs -> throwIO
          $ WrongPackageTypes $ fmap (const ()) errs
        Success pkgs ->
          (fetch (HMIO.toHashMap pkgs)
            >>= putStr . AesonPretty.encodePretty . fmap P.unSha256)
          `catch` (\(Err (P.NixActionError{..})) ->
                      die $ show actionError <> "\n"
                         <> actionStderr)

      -- outermost value was not a record
      e -> throwIO $ ToplevelNotSet (DC.denote e)

    -- | Calls the fetcher.
    fetch pkgs = do
      nowFetching <- newChan
      bracket
        (forkIO $ forever $
          readChan nowFetching
          >>= \(PName name, RetryStatus{rsIterNumber}) -> putErrLn
                (  "Fetching repo for "
                <> name
                <> " (retry "
                <> Protolude.show rsIterNumber <> ")" :: D.Text ))
        killThread
        $ const $ fetchAllParallel nowFetching pkgs

    throws :: Exception e => Either e a -> IO a
    throws (Left  e) = throwIO e
    throws (Right r) = return r
