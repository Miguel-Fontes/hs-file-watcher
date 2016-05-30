module Comando.FileWatcher where

import Comando.Comando
import Actions.Action (actionsList)
import Arquivo.Filter (filtersList)

fileWatcher = Comando "hs-file-wacher" [OptionGroup "Gerais" generalOptions
                                       ,OptionGroup "Filters" (getOptions filtersList)
                                       ,OptionGroup "Actions" (getOptions actionsList)]
    where getOptions = fst . unzip


generalOptions = [Extended ["Caminho"] "Indica o diretório a ser monitorado. Ainda que seja opcional, quando informado, deve ser o primeiro item. Caso não seja informado, o diretório atual será tilizado como alvo.                        Ex: hs-file-watcher c:\\myprj"]
