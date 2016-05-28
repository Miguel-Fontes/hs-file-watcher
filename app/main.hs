import Actions.Action
import Arquivo.Watch
import Arquivo.Filter
import System.Environment
import Parameters.Parameters
import Parameters.Parsers
import Data.Maybe

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
        Left msg -> print msg
        Right p -> do
            lista <- listaArquivos (filters p) (directory p)
            watch (filters p) (directory p) lista (actions p) 3000000
            print "Complete!"