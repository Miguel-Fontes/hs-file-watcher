module Help.Comando where

import Data.List
import Utils.String(rtrim)

data Comando = Comando {
    comando :: String,
    grupos :: [OptionGroup]
}

instance Show Comando where
    show (Comando c o) = c ++ " " ++ show o

data OptionGroup = OptionGroup {
    nome :: String,
    options :: [Option]
}

mapGroup :: (Option -> a) -> OptionGroup -> [a]
mapGroup f (OptionGroup _ ops) = map f ops

instance Show OptionGroup where
    show (OptionGroup d os) = d ++ " - " ++ show os

data Option =   FixedText String
              | Single String String
              | Extended [String] String

instance Show Option where
    show (FixedText s) = s
    show (Single c d) = c ++ " - " ++ d
    show (Extended xs c) = show xs ++ " - " ++ c

usage :: Comando -> String
usage c = comando c ++ " " ++ rtrim (concatMap (concat . mapGroup parseOption) (grupos c))
    where parseOption (FixedText x) = x
          parseOption (Single x _) = "[" ++ x ++ "] "
          parseOption (Extended xs _) =  "[" ++ head xs ++ "] "