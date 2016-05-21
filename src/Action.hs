module Action where

newtype Action = Action {
    exec :: () -> IO()
}

textAction :: String -> Action
textAction str = Action (\() -> print str)