module Watcher.Arquivo where

import Utils.JSON
import Data.List

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

instance JSON Arquivo where
    jStringfy (Arquivo n m d isD) = toJSON [JGroup (JLabel "nome")       (JText n)
                                           ,JGroup (JLabel "modificado") (JText m)
                                           ,JGroup (JLabel "diretorio")  (JText d)
                                           ,JGroup (JLabel "isDiretory") (JBool isD)]
    jStringfyList = brackets . unwords . intersperse "," . foldl step []
        where step acc x = jStringfy x : acc
              brackets s = "[" ++ s ++ "]"