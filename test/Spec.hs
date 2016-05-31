import Watch.Tests as A
import Parameters.Tests as P
import Help.Tests as H
import Utils.String.Tests as US

main :: IO ()
main = do
    A.test
    P.test
    H.test
    US.test