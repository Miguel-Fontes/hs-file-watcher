module Watcher.FileWatcher where

import Comando.Comando
import Watcher.Action (actionsList)
import Watcher.Filter (filtersList)

fileWatcher = Comando "hs-file-wacher" [OptionGroup "Gerais" generalOptions
                                       ,OptionGroup "Filters" (getOptions filtersList)
                                       ,OptionGroup "Actions" (getOptions actionsList)]
    where getOptions = fst . unzip


generalOptions = [Extended ["Path"] "Indica o diretório a ser monitorado. Ainda que seja opcional, quando informado, deve ser o primeiro item. Caso não seja informado, o diretório atual será utilizado como alvo.                        Ex: hs-file-watcher c:\\myprj"]
