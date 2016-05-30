module Help.Printer where

import Help.Comando
import Data.List

printHelp :: Comando -> String
printHelp c = "\n" ++ identation 1 ++ "Uso: " ++  usage c ++ details (grupos c)

details :: [OptionGroup] -> String
details = concat . foldr step []
    where step x acc = (identation 2 ++ nome x ++ "\n" ++ concat (mapGroup optionsDetail x) ++ "\n") : acc

optionsDetail :: Option -> String
optionsDetail (FixedText x) = ""
optionsDetail (Single x d) = x ++ " - " ++ d ++ "\n"
optionsDetail (Extended xs d) = formatColumn 3 38 (unwords xs) ++ formatColumn 0 90 d ++ "\n"

formatColumn :: Int -> Int -> String -> String
formatColumn i x s
    | length s + length (identation i) > x = breakline x (identation i ++ s)
    | otherwise = rpad x (identation i ++ s)

breakline :: Int -> String -> String
breakline 0 _ = " Erro "
breakline x s
    | s !! x == ' ' = take x s ++ "\n" ++ margin 38 ++ rpad 90 (drop (x + 1) s)
    | otherwise = breakline (x-1) s

identation :: Int -> String
identation x = replicate (x * 2) ' '

rpad :: Int -> String -> String
rpad x s = s ++ replicate (x - length s) ' '

lpad :: Int -> String -> String
lpad x s = replicate (x - length s) ' ' ++ s

margin :: Int -> String
margin x = replicate x ' '


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