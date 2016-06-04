module Watcher.Arguments (getArguments) where

import System.Directory
import System.Environment

getArguments :: IO [String]
getArguments = do
    cmdArgs <- getArgs

    if null cmdArgs
        then getConfigFile
        else return cmdArgs


getConfigFile :: IO [String]
getConfigFile = do
    fExist <- doesFileExist ".watcher-config"

    if fExist
        then fmap (concatMap toArgsList . lines) (readFile ".watcher-config")
        else return []


toArgsList :: String -> [String]
toArgsList [] = []
toArgsList args@(x:xs)
    | x == '\"' = takeWhile (/='\"') xs : toArgsList (drop ((+1) . length $ takeWhile (/='\"') xs) xs)
    | x == ' ' = toArgsList (drop 1 args)
    | otherwise = takeWhile (/=' ') args : toArgsList (drop ((+1) . length $ takeWhile (/=' ') args) args)
