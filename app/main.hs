module Main where

import Input.Parsers
import Watcher.Parametros
import Watcher.Watch
import Watcher.FileWatcher
import Watcher.Arguments
import Help.Printer

main :: IO()
main = do
    params <- fmap (parseParameters emptyParams) getArguments

    case params of
        Left msg -> putStrLn msg >>
                    putStrLn (printHelp (TwoColumns (35,100)) fileWatcher)
        Right p -> watch (filters p) (directory p) (actions p) (delay p)