module Arquivo.Filter where

import Arquivo.Arquivo

newtype Filter = Filter {
    run :: Arquivo -> Bool
}

type Directory = String

applyFilters :: [Filter] -> [Arquivo] -> [Arquivo]
applyFilters fs = filter (\ a -> all (`run` a) fs)

applyFilter :: Filter -> [Arquivo] -> [Arquivo]
applyFilter f = filter (f `run`)

customFilter :: (Arquivo -> Bool) -> Filter
customFilter = Filter

noPoints :: Filter
noPoints = Filter (\x -> nome x /="." && nome x /="..")

onlyExtension :: String -> Filter
onlyExtension ext = Filter (\x -> ext == reverse (takeWhile (/= '.') (reverse (nome x))))

excludeDirectory :: Directory -> Filter
excludeDirectory directory = Filter (\x -> dir x /= directory)

