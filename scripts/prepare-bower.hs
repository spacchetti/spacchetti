#!/usr/bin/env runhaskell

{-# LANGUAGE OverloadedStrings #-}

import Control.Monad
import qualified Data.List as List
import qualified Data.Text as Text
import qualified System.Environment as Env
import qualified System.Exit as Exit
import qualified System.Directory as Dir
import qualified System.Process as Proc

overText :: (Text.Text -> Text.Text) -> String -> String
overText f = Text.unpack . f. Text.pack

strip :: String -> String
strip = overText Text.strip

cleanupUrl :: String -> String
cleanupUrl s = "\"" <> prepare s <> ".git\""
  where
    prepare
      = overText
      $ Text.replace "git:" "https:"
      . Text.replace "com:" "com\\/"
      . Text.replace "git@" "https:\\/\\/"
      . Text.replace ".git" ""
      . Text.replace "\"" ""

-- bower doesn't believe in telling us the correct tag names
cleanupVersion :: String -> String
cleanupVersion version
  | not $ List.elem 'v' version
  , withoutQuotes <- overText (Text.replace "\"" "") version
  = "\"v" <> withoutQuotes <> "\""
cleanupVersion version = version

run :: String -> IO ()
run input' = do
  test <- Dir.doesFileExist file

  when (not test) $ void $ Proc.readCreateProcess downloadJsonCmd ""

  (exitCode, depsOut, _) <- Proc.readCreateProcessWithExitCode getDeps ""
  dependencies <- case exitCode of
    Exit.ExitSuccess -> pure $ strip depsOut
    Exit.ExitFailure _ -> pure ""

  version <- cleanupVersion <$> readCmd getVersion
  url' <- readCmd getUrl
  url <- if url' == "null"
    then do
      -- naively use homepage if url isn't specified for repo
      output <- readCmd getHomepage
      pure $ "\"" <> output <> ".git" <> "\""
    else
      pure $ cleanupUrl url'

  putStrLn $ input <> " = mkPackage"
  putStrLn dependencies
  putStrLn url
  putStrLn version

  where
    readCmd cmd = strip <$> Proc.readCreateProcess cmd ""

    input = List.filter ((/=) '"') input'
    file = "bower-info/" <> input <> ".json"

    replaceFile = Text.replace "$file" (Text.pack file)
    replaceInput = Text.replace "$input" (Text.pack input)
    mkShell = Proc.shell . overText (replaceInput . replaceFile)

    downloadJsonCmd = mkShell "mkdir -p bower-info && bower info purescript-$input --json > $file"
    getDeps = mkShell "cat $file | jq '.latest.dependencies | keys | map (.[11:])'"
    getVersion = mkShell "cat $file | jq '.latest.version'"
    getUrl = mkShell "cat $file | jq '.latest.repository.url'"
    getHomepage = mkShell "cat $file | jq '.latest.homepage' -r"

main :: IO ()
main = do
  args <- Env.getArgs
  case args of
    [pkg] -> run pkg
    _ -> fail errorMsg

errorMsg :: String
errorMsg = "\n\
\  I need one arg for what the bower package name is without the preceding `purescript-`\n\
\  e.g. `./scripts/prepare-bower.hs yargs`\n"
