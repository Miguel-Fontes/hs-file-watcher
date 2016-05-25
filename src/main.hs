import Action
import Arquivo.Watch
import Arquivo.Filter
import System.Environment
import Parameters.Parameters
import Parameters.Parsers
import Data.Maybe

main :: IO()
main = do
    -- BUG: Aplicação funcionando apenas com diretórios E quando o diretório é informado com um trailling \\
    --      1 - Tratar argumento de entrada para identificar se é arquivo ou diretório
    --      2a - Se for arquivo, obter o nome do arquivo e o caminho do diretório da String e construir o tipo Arquivo.
    --      2b - Se for diretório, garantir que exista um trailling \\.
    --      OBS: A necessidade do \\ é causada pelo uso da função setCurrentdirectory em Arquivo.Watch.listaArquivos
    args <- getArgs
    print args

    let --dir = "C:\\Desenv\\hs-file-watcher\\"
        --f = [excludeDirectories ["node_modules", ".git", "bower_components"]]
        p = fst $ fromJust (parseParameters args)
        dir = directory p
        fs = filters p

    lista <- listaArquivos fs dir
    watch fs dir lista (textAction "############# ARQUIVOS ALTERADOS! ################") 3000000
    print "Complete!"

    -- Build ---> ghc -o ./../dist/hs-file-watcher main -odir ./../dist/ -hidir ./../dist/