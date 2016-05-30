module Comando.FileWatcher where

import Comando.Comando
import Actions.Action (actionsList)
import Arquivo.Filter (filtersList)

fileWatcher = Comando "hs-file-wacher" [OptionGroup "" [FixedText "[Caminho] "]
                                       ,OptionGroup "Filters" (getOptions filtersList)
                                       ,OptionGroup "Actions" (getOptions actionsList)]
    where getOptions = fst . unzip