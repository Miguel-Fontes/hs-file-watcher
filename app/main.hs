import System.Environment
import Data.Maybe

import Parameters.Parameters
import Parameters.Parsers
import Actions.Action
import Arquivo.Watch
import Arquivo.Filter

main :: IO()
main = do
    args <- getArgs

    -- Esta configuração abaixo é para testes. Deve ser removida em momento posterior.
    params <- if null args
                  then return $ Right Parameters {directory = "C:\\Desenv\\hs-file-watcher\\"
                                                 ,actions = [textAction ["=====>>>>>>>> Arquivos Alterados!"]]
                                                 ,filters = [excludeDirectories [".git", "dist"]
                                                            ,onlyExtensions ["hs"]]}
                  else return $ parseParameters args

    case params of
        Left msg -> putStrLn msg
        Right p -> watch (filters p) (directory p) (actions p) 3000000