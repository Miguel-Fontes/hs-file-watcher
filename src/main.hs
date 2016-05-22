import Action
import Arquivo.Watch

main :: IO()
main = do
    --dir <- getLine -- Ajustar entrada via linha de comando posteriormente
    let dir = "C:\\Desenv\\hs-file-watcher\\"
    lista <- listaArquivos dir
    watch dir lista (textAction "############# ARQUIVOS ALTERADOS! ################") 3000000
    print "Complete!"