#!/usr/bin/env runhaskell

-- | script for calling https://github.com/justinwoo/spac-update
-- | ported from perl, please see git history for original

import qualified Data.List as List
import qualified Control.Concurrent.Async as Async
import qualified System.Process as Proc

newtype Dep = Dep String

getDeps :: IO [Dep]
getDeps = do
  let process = Proc.shell "jq 'keys[]' packages.json"
  out <- Proc.readCreateProcess process ""
  pure $ Dep <$> List.lines out

prepareBower :: Dep -> IO ()
prepareBower (Dep dep) = do
  let process = Proc.shell $ "spac-update prepare-bower " <> dep
  _ <- Proc.readCreateProcess process ""
  pure ()

runFromBower :: Dep -> IO ()
runFromBower  (Dep dep) = do
  Proc.callCommand $ "spac-update from-bower " <> dep

main :: IO ()
main = do
  deps <- getDeps

  Async.mapConcurrently_ prepareBower deps
  putStrLn "Finished prepare-bower"

  _ <- traverse runFromBower deps
  putStrLn "Finished from-bower"
