import Action
import Arquivo.Watch
import Arquivo.Filter
import System.Environment

main :: IO()
main = do

    let dir = "C:\\Desenv\\hs-file-watcher\\"
        filters = [noPoints, excludeDirectories ["node_modules", ".git", "bower_components"]]
    args <- getArgs
    lista <- listaArquivos filters dir
    watch filters dir lista (textAction "############# ARQUIVOS ALTERADOS! ################") 3000000
    print "Complete!"