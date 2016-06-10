module Help.Printer (printHelp, usage, Layout (TwoColumns)) where

import Data.List

import Help.Command
import Utils.String

data Layout = TwoColumns (Int, Int)
larguras (TwoColumns l) = l

printHelp :: Layout -> Command -> String
printHelp l c = "\n" ++ identation 1 ++ "Uso: " ++  usage c ++ details l (grupos c)

usage :: Command -> String
usage c = cmd c ++ " " ++ rtrim (concatMap (brackets . concat . mapGroup parseOption) (grupos c)) ++ "\n\n"
    where parseOption (FixedText x) = x
          parseOption (Single x _) = "[" ++ x ++ "]"
          parseOption (Extended xs _) =  "[" ++ head xs ++ "]"
          brackets x = "[" ++ x ++ "] "

details :: Layout -> [OptionGroup] -> String
details l = concat . foldr step []
    where step x acc = (identation 2 ++ groupName x ++ "\n" ++ concat (mapGroup (optionsDetail l) x)) : acc

optionsDetail :: Layout -> Option -> String
optionsDetail _ (FixedText x) = ""
optionsDetail (TwoColumns (a, b)) (Single x d) =
    formatColumn 0 3 a x ++ formatColumn (a + length (identation 3)) 0 b d ++ "\n\n"
optionsDetail (TwoColumns (a, b)) (Extended xs d) =
    formatColumn 0 3 a (unwords xs) ++ formatColumn (a + length (identation 3)) 0 b d ++ "\n\n"

breaklines :: Int -> String -> String
breaklines 0 _ = " Erro "
breaklines col s = breaklineIter col s
    where breaklineIter x s
              | length s <= col = s
              | s !! x == ' ' = take x s ++ "\n" ++ breaklines col (rpad col (drop (x + 1) s))
              | otherwise = breaklines (x-1) s

-- formatColumn' -> Margin -> Identation -> Column Size -> Texto
formatColumn :: Int -> Int -> Int -> String -> String
formatColumn m i col s = (init . unlines . addMargin) $ foldr step [] textLines
    where textLines = lines s
          addMargin xs = (identation i ++ head xs) : map ((margin m ++) . (identation i ++)) (tail xs)
          step x acc
              | length x > col = (lines $ breaklines col x) ++ acc
              | otherwise = rpad col x : acc