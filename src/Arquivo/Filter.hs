module Arquivo.Filter where

import Arquivo.Arquivo

type Tag = String

newtype Filter = Filter {
    value :: (Tag, Arquivo -> Bool)
}

instance Show Filter where
    show (Filter (t, _)) = t

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

excludeFile :: String -> Filter
excludeFile name = Filter ("excludeFile: " ++ name, \x -> not (nome x == name && not (isDirectory x)))

excludeFiles :: [String] -> Filter
excludeFiles names = Filter ("excludeFiles: " ++ show names
                            ,\x -> all (\z -> not (nome x == z && not (isDirectory x))) names)

onlyExtension :: String -> Filter
onlyExtension ext = Filter ("onlyExtension: " ++ ext
                           ,\x -> isDirectory x || ext == reverse (takeWhile (/= '.') (reverse (nome x))))

onlyExtensions :: [String] -> Filter
onlyExtensions exts = Filter ("onlyExtension: " ++ show exts
                           ,\x -> all (\ext -> isDirectory x || ext == reverse (takeWhile (/= '.') (reverse (nome x))))exts)

excludeDirectory :: Directory -> Filter
excludeDirectory directory = Filter ("excludeDirectory: " ++ directory
                                    ,\x -> not (nome x == directory && isDirectory x))

excludeDirectories :: [Directory] -> Filter
excludeDirectories directories = Filter ("excludeDirectories: " ++ show directories
                                        ,\x -> all (\z -> not (nome x == z && isDirectory x)) directories)