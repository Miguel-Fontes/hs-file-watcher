module Actions.Action where

import System.Process

newtype Action = Action (Tag,  () -> IO())

type Tag= String

instance Show Action where
    show (Action (tag, _)) = tag

instance Eq Action where
    Action (t1, _) == Action (t2, _) = t1 == t2

exec :: Action -> (() -> IO())
exec (Action (_, a)) = a

textAction :: [String] -> Action
textAction str = Action ("textAction: " ++ show str, \() -> print (unwords str))

cmdAction :: [String] -> Action
cmdAction cmd = Action ("cmdAction: " ++ show cmd, \() -> callCommand (concat cmd))