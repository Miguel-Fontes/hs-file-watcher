module Actions.Action (
    exec
  , textAction
  , cmdAction
  , printChangedAction
  , actionsList
  , Action
  ) where

import System.Process
import Control.Exception

import Arquivo.Arquivo
import Comando.Comando

newtype Action a = Action (Tag,  [a] -> IO())

type Tag = String

instance Show (Action a) where
    show (Action (tag, _)) = tag

instance Eq (Action a) where
    Action (t1, _) == Action (t2, _) = t1 == t2

exec :: Action a -> ([a] -> IO())
exec (Action (_, a)) = a

textAction :: [String] -> Action a
textAction str = Action ("textAction: " ++ show str, \_ -> print (unwords str))

cmdAction :: [String] -> Action a
cmdAction cmd = Action ("cmdAction: " ++ show cmd
                       , \_ -> catch (callCommand (concat cmd))
                                     (\e -> putStrLn $ "\n-> Erro ao executar o comando \'"
                                            ++ concat cmd ++ "\':\n"
                                            ++ show (e :: IOException)
                                            ++ "\nPressione CTRL+C para interromper a execução..."))

printChangedAction :: [String] -> Action Arquivo
printChangedAction _ = Action ("printChangedAction", mapM_ print)

actionsList :: [(Option, [String] -> Action Arquivo)]
actionsList = [(Extended ["--p", "--print"]
                         "Imprime o texto indicado quando mudanças forem identificadas. O argumento de entrada é o texto a ser impresso Ex: hs-file-watcher --p \"Alterações!\""
                         , textAction)
              ,(Extended ["--pc", "--print-changed"]
                         "Exibe lista de arquivos que sofreram alterações. Comando não contém argumentos de entrada Ex: hs-file-watcher --pc"
                         , printChangedAction)
              ,(Extended ["--cmd", "--command"]
                         "Executa um conjunto de comandos a cada modificação detectada. Os argumentos de entrada são os comandos à executar separados por espaços (Usar \" para comandos que contenham espaços). Ex: hs-file-watcher --cmd \"stack build\" \"stack install\" "
                         , cmdAction)]