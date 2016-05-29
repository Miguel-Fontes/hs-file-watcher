import Arquivo.Tests as A
import Parameters.Tests as P
import Actions.Tests as AC
import Help.Tests as H
import Utils.String.Tests as US

main :: IO ()
main = do
    A.test
    P.test
    AC.test
    H.test
    US.test