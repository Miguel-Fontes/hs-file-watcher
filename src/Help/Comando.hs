module Help.Comando where

import Data.List

data Comando = Comando {
    comando :: String,
    options :: [[Option]]
}

instance Show Comando where
    show (Comando c o) = c ++ " " ++ show o

data Option = Single String | Extended [String]

instance Show Option where
    show (Single s) = s
    show (Extended xs) = show xs

usage :: Comando -> String
usage c = comando c ++ " " ++ (rtrim . concatMap ((\ x -> "[" ++ x ++ "] ") . getShorthand . head)) (options c)
    where getShorthand (Single x) = x
          getShorthand (Extended xs) = head xs

rtrim :: String -> String
rtrim xs = rtrimIter (reverse xs)
    where rtrimIter (x:xs)
            | x == ' ' = rtrimIter xs
            | otherwise = reverse (x:xs)