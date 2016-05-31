module Arquivo.Filter (
      Filter
    , run
    , applyFilters
    , applyFilter
    , customFilter
    , noPoints
    , excludeFiles
    , onlyExtensions
    , excludeDirectories
    , filtersList
) where

import Arquivo.Arquivo
import qualified Comando.Comando as C

type Tag = String

newtype Filter = Filter {
    value :: (Tag, Arquivo -> Bool)
}

instance Show Filter where
    show (Filter (t, _)) = t

instance Eq Filter where
    Filter (t1, _) == Filter (t2, _) = t1 == t2

type Directory = String

run :: Filter -> (Arquivo -> Bool)
run (Filter (_, f)) = f

applyFilters :: [Filter] -> [Arquivo] -> [Arquivo]
applyFilters fs = filter (\ a -> all (`run` a) fs)

applyFilter :: Filter -> [Arquivo] -> [Arquivo]
applyFilter f = filter (run f)

customFilter :: (Arquivo -> Bool) -> Filter
customFilter f = Filter ("CustomFilter", f)

noPoints :: Filter
noPoints = Filter ("noPoints", \x -> nome x /="." && nome x /="..")

excludeFiles :: [String] -> Filter
excludeFiles names = Filter ("excludeFiles: " ++ show names
                            ,\x -> all (\z -> not (nome x == z && not (isDirectory x))) names)

onlyExtensions :: [String] -> Filter
onlyExtensions exts = Filter ("onlyExtensions: " ++ show exts
                           ,\x -> all (\ext -> isDirectory x || ext == reverse (takeWhile (/= '.') (reverse (nome x))))exts)

excludeDirectories :: [Directory] -> Filter
excludeDirectories directories = Filter ("excludeDirectories: " ++ show directories
                                        ,\x -> all (\z -> not (nome x == z && isDirectory x)) directories)

filtersList :: [(C.Option, [String] -> Filter)]
filtersList = [(C.Extended ["--ed", "--exclude-directories"]
                            "Exclui os diretórios listados do monitoramento. Os argumentos de entrada são os nomes dos diretórios separados por espaços. Ex: hs-file-watcher --ed .stack-work dist log"
                            , excludeDirectories)
              ,(C.Extended ["--ef", "--exclude-files"]
                            "Exclui os arquivos listados do monitoramento. Os argumentos de entrada são os nomes dos arquivos separados por espaços. Ex: hs-file-watcher --ef readme.md myprj.cabal log.txt"
                            , excludeFiles)
              ,(C.Extended ["--exts", "--only-extensions"]
                            "Limita o monitoramento aos arquivos com as extensões listadas. Os argumentos de entrada são as extensões seaparadas por espaços. Ex: hs-file-watcher --exts hs md cabal"
                            , onlyExtensions)]
