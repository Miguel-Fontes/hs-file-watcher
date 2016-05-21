module Arquivo.Arquivo where

data Arquivo = Arquivo {
    nome :: String,
    modificado :: String,
    dir :: String
}

instance Show Arquivo where
    show (Arquivo n m d) = "Arquivo: " ++ n ++ " - Dir: " ++ d ++ " - Modificado:  " ++ m ++ "\n"

instance Eq Arquivo where
    (Arquivo n1 m1 d1) == (Arquivo n2 m2 d2) = (n1 == n2) && (m1 == m2) && (d1 == d2)
