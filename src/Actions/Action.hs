module Actions.Action where

import System.Process
import Control.Exception

import Arquivo.Arquivo

newtype Action a = Action (Tag,  [a] -> IO())

type Tag= String

instance Show (Action a) where
    show (Action (tag, _)) = tag

instance Eq (Action a) where
    Action (t1, _) == Action (t2, _) = t1 == t2

exec :: Action a -> ([a] -> IO())
exec (Action (_, a)) = a

textAction :: [String] -> Action a
textAction str = Action ("textAction: " ++ show str, \_ -> print (unwords str))

cmdAction :: [String] -> Action a
cmdAction cmd = Action ("cmdAction: " ++ show cmd, \_ -> catch (callCommand (concat cmd))
                                                               (\e -> putStrLn $ "\n-> Erro ao executar o comando \'"
                                                                      ++ concat cmd ++ "\':\n"
                                                                      ++ show (e :: IOException)
                                                                      ++ "\nPressione CTRL+C para interromper a execução..."))

printChangedAction :: [String] -> Action Arquivo
printChangedAction _ = Action ("printChangedAction", mapM_ print)