import Action
import Arquivo.Watch

main :: IO()
main  = do
    lista <- listaArquivos "."
    watch lista (textAction "############# ARQUIVOS ALTERADOS! ################") 3000000
    print "Complete!"