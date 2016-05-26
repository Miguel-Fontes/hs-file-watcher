module Actions.Action where

import System.Process

newtype Action = Action (Tag,  () -> IO())

type Tag= String

instance Show Action where
    show (Action (tag, _)) = tag

exec :: Action -> (() -> IO())
exec (Action (_, a)) = a

textAction :: [String] -> Action
textAction str = Action ("textAction: " ++ show str, \() -> print (unwords str))

cmdAction :: [String] -> Action
cmdAction cmd = Action ("cmdAction: " ++ show cmd, \() -> callCommand (concat cmd))