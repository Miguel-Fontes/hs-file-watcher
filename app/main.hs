import System.Environment

import Parameters.Parameters
import Parameters.Parsers
import Arquivo.Watch

main :: IO()
main = do
    params <- fmap parseParameters getArgs

    case params of
        Left msg -> putStrLn msg
        Right p -> watch (filters p) (directory p) (actions p) 3000000