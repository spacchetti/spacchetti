#!/usr/bin/env runhaskell

-- | This is a script for calling `from-bower` on all packages defined in the `packages.json` file. Make sure to delete `bower-info/` to not use cached information.
-- | See the Spachetti repository https://github.com/spacchetti/spacchetti for more details.
-- | ported from perl, please see git history for original


{-# LANGUAGE CPP #-}

import qualified Data.List as List
import qualified Control.Concurrent.Async as Async
import qualified System.Process as Proc

newtype Dirname = Dirname String

getDirName :: IO Dirname
getDirName = do
  out <- Proc.readProcess "dirname" [__FILE__] ""
  let formatted = (<>) "./" $ List.filter ((/=) '\n') out
  pure $ Dirname formatted

newtype Dep = Dep String

getDeps :: IO [Dep]
getDeps = do
  let process = Proc.shell "jq 'keys[]' packages.json"
  out <- Proc.readCreateProcess process ""
  pure $ Dep <$> List.lines out

prepareBower :: Dirname -> Dep -> IO ()
prepareBower (Dirname dirname) (Dep dep) = do
  let process = Proc.shell $ dirname <> "/prepare-bower.hs " <> dep
  _ <- Proc.readCreateProcess process ""
  pure ()

runFromBower :: Dirname -> Dep -> IO ()
runFromBower (Dirname prefix) (Dep dep) = do
  Proc.callCommand $ prefix <> "/from-bower.pl " <> dep

main :: IO ()
main = do
  deps <- getDeps
  dirname <- getDirName

  Async.mapConcurrently_ (prepareBower dirname) deps
  putStrLn "Finished prepare-bower"

  _ <- traverse (runFromBower dirname) deps
  putStrLn "Finished from-bower"
