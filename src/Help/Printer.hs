module Help.Printer (printHelp, usage, Layout (TwoColumns)) where

import Data.List

import Help.Command
import Utils.String

data Layout = TwoColumns (Int, Int)
larguras (TwoColumns l) = l

printHelp :: Layout -> Command -> String
printHelp l c = identation 1 ++ "Uso: " ++  usage c ++ details l (grupos c)

usage :: Command -> String
usage c = cmd c ++ " " ++ rtrim (concatMap (enbracket . concat . mapGroup parseOption) (grupos c)) ++ "\n\n"
    where parseOption (FixedText x) = x
          parseOption (Single x _) = "[" ++ x ++ "]"
          parseOption (Extended xs _) =  "[" ++ head xs ++ "]"
          enbracket x = "[" ++ x ++ "] "

details :: Layout -> [OptionGroup] -> String
details l = concat . foldr step []
    where step x acc = (identation 2 ++ groupName x ++ "\n" ++ concat (mapGroup (optionsDetail l) x)) : acc

optionsDetail :: Layout -> Option -> String
optionsDetail _ (FixedText x) = ""
optionsDetail (TwoColumns (a, b)) (Single x d) =
    formatColumn 0 3 a x ++ formatColumn (a + length (identation 3)) 0 b d ++ "\n\n"
optionsDetail (TwoColumns (a, b)) (Extended xs d) =
    formatColumn 0 3 a (unwords xs) ++ formatColumn (a + length (identation 3)) 0 b d ++ "\n\n"

formatColumn :: Int -> Int -> Int -> String -> String
formatColumn m i col s
    | length s > col = breaklines m i col s
    | otherwise = identation i ++ rpad col s

breaklines :: Int -> Int -> Int -> String -> String
breaklines _ i 0 _ = " Erro "
breaklines m i col s = breaklineIter m i col s
    where breaklineIter m i x s
              | length s <= col = s
              | s !! x == ' ' = take x s ++ "\n" ++ margin m
                                         ++ identation i
                                         ++ breaklines m i col (rpad col (drop (x + 1) s))
              | otherwise = breaklines m i (x-1) s