module Action where

newtype Action = Action {
    run :: () -> IO()
}

textAction :: String -> Action
textAction str = Action (\() -> print str)