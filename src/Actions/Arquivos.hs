module Actions.Arquivos where

import Actions.Action
import Arquivo.Arquivo

printChangedAction :: [String] -> Action Arquivo
printChangedAction _ = Action ("printChangedAction", mapM_ print)