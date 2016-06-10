module Watcher.FileWatcher where

import Help.Command
import Watcher.Action (actionsList)
import Watcher.Filter (filtersList)
import Watcher.Modificadores (modificadoresList)

fileWatcher = Command "hs-file-wacher" [OptionGroup "Gerais" generalOptions
                                       ,OptionGroup "Modificadores" (getOptions modificadoresList)
                                       ,OptionGroup "Filters" (getOptions filtersList)
                                       ,OptionGroup "Actions" (getOptions actionsList)]
    where getOptions = fst . unzip


generalOptions = [Extended ["Path"] "Indica o diretório a ser monitorado. Ainda que seja opcional, quando informado, deve ser o primeiro item. Caso não seja informado, o diretório atual será utilizado como alvo.\nEx: hs-file-watcher c:\\myprj"]