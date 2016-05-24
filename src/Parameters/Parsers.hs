module Parameters.Parsers where

import Parameters.Parameters
import Arquivo.Filter
import Action

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
    | fst fs == "-ed" = let fs' = getSection (snd fs)
                         in parseFilters (p { filters = excludeDirectory (fst fs') : filters p }, xs)
    | otherwise = Nothing
    where fs = getSection x

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