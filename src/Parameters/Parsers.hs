module Parameters.Parsers where

import Parameters.Parameters
import Arquivo.Filter
import Action

import Data.List

formatDir :: String -> String
formatDir x = case takeWhile (=='\\') (reverse x) of
                  [] -> x ++ "\\"
                  (_:_) -> x

parseFile :: String -> (String, String)
parseFile x = case takeWhile (/='\\') (reverse x) of
                  [] -> ("", x)
                  xs -> (reverse xs, reverse $ drop (length xs) (reverse x))

parseFilters :: (Parameters, [String]) -> Maybe (Parameters, [String])
parseFilters (p, []) = Just (p, [])
parseFilters (p, x:xs)
    | x == "--ed" = let dirs = takeWhile ((/='-') . head) xs
                     in parseFilters (p{filters = excludeDirectories dirs : filters p}, drop (length dirs) xs)
    | x == "--only-ext" = let ext = head xs
                           in parseFilters (p{filters = onlyExtension ext : filters p}, drop 1 xs)
    | x == "--ef" = let files = takeWhile ((/='-') . head) xs
                     in parseFilters (p{filters = excludeFiles files : filters p}, drop (length files) xs)
    | otherwise = Nothing

parseAction :: (Parameters, [String]) -> Maybe (Parameters, [String])
parseAction (p, x:xs) = Just (p { actions = x }, xs)

parseDir :: (Parameters, [String]) -> Maybe (Parameters, [String])
parseDir (p, x:xs) = Just (p { directory = formatDir x }, xs)

getSection :: String -> (String, String)
getSection xs = (section, drop (length section + 1) xs)
    where section = takeWhile (/=' ') xs

parseParameters :: [String] -> Maybe (Parameters, [String])
parseParameters xs = parseDir (emptyParams, xs) >>= parseAction >>= parseFilters

-- -hs-watcher "C:\Desenv" "textAction arquivoAlterado!" -ed node_modules bower_components -ef readme.md -only-ext hs

-- hs-file-watcher.exe C:\desenv\hs-file-watcher\ "Arquivos Alterados" -ef node_modules bower_components
-- ["C:\\desenv\\hs-file-watcher\\","Printme","Arquivos Alterados","-ef","node_modules","bower_components"]