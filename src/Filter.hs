module Filter where

import Arquivo

newtype Filter = Filter {
    run :: Arquivo -> Bool
}

type Directory = String

customFilter :: (Arquivo -> Bool) -> Filter
customFilter = Filter

noPoints :: Filter
noPoints = Filter (\x -> nome x /="." && nome x /="..")

excludeDirectory :: Directory -> Filter
excludeDirectory directory = Filter (\x -> dir x /= directory)

applyFilters :: [Filter] -> [Arquivo] -> [Arquivo]
applyFilters fs = filter (\ a -> all (`run` a) fs)

applyFilter :: Filter -> [Arquivo] -> [Arquivo]
applyFilter f = filter (f `run`)
