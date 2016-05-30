module Help.Printer where

import Data.List

import Comando.Comando
import Utils.String

data Layout = TwoColumns (Int, Int)
larguras (TwoColumns l) = l

printHelp :: Layout -> Comando -> String
printHelp l c = "\n" ++ identation 1 ++ "Uso: " ++  usage c ++ details l (grupos c)

usage :: Comando -> String
usage c = comando c ++ " " ++ rtrim (concatMap (concat . mapGroup parseOption) (grupos c))
    where parseOption (FixedText x) = x
          parseOption (Single x _) = "[" ++ x ++ "] "
          parseOption (Extended xs _) =  "[" ++ head xs ++ "] "

details :: Layout -> [OptionGroup] -> String
details l = concat . foldr step []
    where step x acc = (identation 2 ++ groupName x ++ "\n" ++ concat (mapGroup (optionsDetail l) x) ++ "\n") : acc


optionsDetail :: Layout -> Option -> String
optionsDetail _ (FixedText x) = ""
optionsDetail _ (Single x d) = x ++ " - " ++ d ++ "\n"
optionsDetail (TwoColumns (a, b)) (Extended xs d) =
    formatColumn 0 3 a (unwords xs) ++ formatColumn (a + length (identation 3)) 0 b d ++ "\n"

formatColumn :: Int -> Int -> Int -> String -> String
formatColumn m i col s
    | length s > col = breakline m i col s
    | otherwise = identation i ++ rpad col s

breakline :: Int -> Int -> Int -> String -> String
breakline _ i 0 _ = " Erro "
breakline m i col s = breaklineIter m i col s
    where breaklineIter m i x s
              | length s <= col = s
              | s !! x == ' ' = take x s ++ "\n" ++ margin m
                                         ++ identation i
                                         ++ breakline m i col (rpad col (drop (x + 1) s))
              | otherwise = breakline m i (x-1) s