module Help.Printer (printHelp, usage, Layout (TwoColumns)) where

import Data.List

import Help.Command
import Utils.String

data Layout = TwoColumns (Int, Int)
larguras (TwoColumns l) = l

type Column = (Int, [String])

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
    buildLines 3 (formatColumn a x) (formatColumn b d) ++ "\n"
optionsDetail (TwoColumns (a, b)) (Extended xs d) =
    buildLines 3 (formatColumn a (unwords xs)) (formatColumn b d) ++ "\n"

breaklines :: Int -> String -> String
breaklines 0 _ = " Erro "
breaklines col s = breaklineIter col s
    where breaklineIter x s
              | length s <= col = rpad col s
              | s !! x == ' ' = take x s ++ "\n" ++ breaklines col (rpad col (drop (x + 1) s))
              | otherwise = breaklines (x-1) s

formatColumn :: Int -> String -> Column
formatColumn col s = (col, foldr step [] textLines)
    where textLines = lines s
          step x acc
              | length x > col = (lines $ breaklines col x) ++ acc
              | otherwise = rpad col x : acc

buildLines :: Int -> Column -> Column -> String
buildLines i (colA, (x:xs)) (colB, (y:ys)) = buildLines' i colA colB (x:xs) (y:ys)

buildLines' :: Int -> Int -> Int -> [String] -> [String] -> String
buildLines' _ colA colB [] []         = ""
buildLines' i colA colB (x:xs) (y:ys) = identation i ++ x ++ y ++ "\n" ++ buildLines' i colA colB xs ys
buildLines' i colA colB (x:xs) []     = identation i ++ x ++ rpad colB "" ++ "\n" ++ buildLines' i colA colB xs []
buildLines' i colA colB [] (y:ys)     = identation i ++ rpad colA "" ++ y ++ "\n" ++ buildLines' i colA colB [] ys


{-
A formatação em colunas deve funcionar de maneira mais adequada.
Se eu tenho duas colunas, mesmo que uma célula não possua valor, ela deve estar preenchida com espaços em branco.
Isto é essencial para que a segunda coluna (ou as próximas) sejam corretamente preenchidas. Isto elimina a necessidade
de adição de uma MARGEM.

Existem um desafio: expandir o algoritmo para qualquer quantidade de colunas. Não irei considera-lo agora.

Preciso de dois procedimentos:
1) Formatar Dados: Irá obter os dados e formata-los de acordo com o tamnho de uma coluna. É análogo ao formatColumn atual, mas sem se preocupar com margens. Aliás, a própria identação deve ser uma preocupação da linha
2) Uma função de construção de linhas que recebe as células das colunas formatadas e as dispôe sequencialaente. Em outras palavras, recebe a saída da função anterior 1). Esta é a função que irá pensar em identação.

Int -> [String] [String]
buildLines' 3 (formatColumns colA xs) (formatColumns colB ys)

buildLines _ [] [] = ""
buildLines i (x:xs) (y:ys) = identation i ++ x ++ y ++ \n ++ buildLines i xs ys
buildLines i (x:xs) []     = identation i ++ x ++ rpad colB ++ buildLines i xs []
buildLines i [] (y:ys)     = identation i ++ rpad colA ++ y ++ buildLines i xs []

-}