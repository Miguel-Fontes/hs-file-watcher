module Action where

newtype Action = Action (Tag,  () -> IO())

type Tag= String

instance Show Action where
    show (Action (tag, _)) = tag

exec :: Action -> (() -> IO())
exec (Action (_, a)) = a

textAction :: String -> Action
textAction str = Action ("textAction: " ++ str, \() -> print str)