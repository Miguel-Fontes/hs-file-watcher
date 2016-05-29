module Utils.String where

rtrim :: String -> String
rtrim xs = rtrimIter (reverse xs)
    where rtrimIter (x:xs)
            | x == ' ' = rtrimIter xs
            | otherwise = reverse (x:xs)