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
                  then return Parameters {directory = "C:\\Desenv\\hs-file-watcher\\"
                                         ,actions = [textAction ["=====>>>>>>>> Arquivos Alterados!"]]
                                         ,filters = [excludeDirectories [".git", "dist"], onlyExtensions ["hs"]]}
                  else return $ fst (fromJust (parseParameters args))

    let dir = directory params
        fs = filters params
        act = actions params

    lista <- listaArquivos fs dir
    watch fs dir lista act 3000000
    print "Complete!"

    -- Build ---> ghc -o ./../dist/hs-file-watcher main -odir ./../dist/ -hidir ./../dist/