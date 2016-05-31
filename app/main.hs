import System.Environment

import Parameters.Parameters
import Parameters.Parsers
import Watcher.Watch
import Watcher.FileWatcher
import Help.Printer

main :: IO()
main = do
    params <- fmap parseParameters getArgs

    case params of
        Left msg -> putStrLn msg >>
                    putStrLn (printHelp (TwoColumns (35,100)) fileWatcher)
        Right p -> watch (filters p) (directory p) (actions p) 3000000

