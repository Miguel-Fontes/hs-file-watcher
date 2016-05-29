import Arquivo.Tests as A
import Parameters.Tests as P
import Actions.Tests as AC

main :: IO ()
main = do
    A.test
    P.test
    AC.test