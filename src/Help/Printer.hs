module Help.Printer where

import Data.List

import Help.Comando
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
    where step x acc = (identation 2 ++ nome x ++ "\n" ++ concat (mapGroup (optionsDetail l) x) ++ "\n") : acc


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

-- REMOVER ISSO AQUI PLZ
hsCommand1 = Comando "hs-file-wacher" [OptionGroup "" [FixedText "[Caminho] "]
                                     ,OptionGroup "Filters"  filtersList1
                                     ,OptionGroup "Actions"  actionsList1]


filtersList1 :: [Option]
filtersList1 = [Extended ["--ed", "--exclude-directories"]
                         "Exclui os diretórios listado do monitoramento. Os argumentos de entrada são os nomes dos diretórios. Ex: -ed .stack-work dist log"
              ,Extended ["--ef", "--exclude-files"]
                         "Exclui os arquivos indicados do monitoramento. Os argumentos de entrada são os nomes dos arquivos. Ex: --ef readme.md myprj.cabal log.txt"
              ,Extended ["--exts", "--only-extensions"]
                         "Limita o monitoramento à apenas às extensões listadas. Os argumentos de entrada são as extensões. Ex: --exts hs"]

actionsList1 :: [Option]
actionsList1 = [Extended ["--p", "--print"]
                         "Imprime o texto indicado quando mudanças forem identificadas. Ex: --p \"Alterações!\""
              ,Extended ["--pc", "--print-changed"]
                         "Exibe lista de arquivos que sofreram alterações no console. Ex: --pc"
              ,Extended ["--cmd", "--command"]
                         "Executa um comando cada vez que uma modificação é detectada. Os argumentos de entrada são os comandos à executar. Ex: --cmd \"stack build\" \"stack install\" "]