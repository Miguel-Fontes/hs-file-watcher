import System.Environment

import Parameters.Parsers
import Watcher.Parametros
import Watcher.Watch
import Watcher.FileWatcher
import Help.Printer

main :: IO()
main = do
    params <- fmap (parseParameters emptyParams) getArgs

    case params of
        Left msg -> putStrLn msg >>
                    putStrLn (printHelp (TwoColumns (35,100)) fileWatcher)
        Right p -> watch (filters p) (directory p) (actions p) 3000000

