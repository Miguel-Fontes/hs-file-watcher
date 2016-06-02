module Watcher.Arquivo where

data Arquivo = Arquivo {
    nome :: String,
    modificado :: String,
    dir :: String,
    isDirectory :: Bool
}

instance Show Arquivo where
    show (Arquivo n m d isD) = "Arquivo: " ++ n ++ " -- Diretório: " ++ d ++ " -- Modificado:  " ++ m ++ " -- isDirectory: " ++ show isD ++ "\n"

instance Eq Arquivo where
    (Arquivo n1 m1 d1 _) == (Arquivo n2 m2 d2 _) = (n1 == n2) && (m1 == m2) && (d1 == d2)
