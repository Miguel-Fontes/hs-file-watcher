module Arquivo.Filter where

import Arquivo.Arquivo

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