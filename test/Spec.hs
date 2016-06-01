import qualified Watcher.Tests as A
import qualified Watcher.Parametros.Tests as T
import qualified Parameters.Tests as P
import qualified Help.Tests as H
import qualified Utils.String.Tests as US

main :: IO ()
main = do
    A.test
    P.test
    H.test
    US.test
    T.test