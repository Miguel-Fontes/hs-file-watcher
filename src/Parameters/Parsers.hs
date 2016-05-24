module Parameters.Parsers where

import Parameters.Parameters
import Arquivo.Filter
import Action

formatDir :: String -> Parameters
formatDir x = case takeWhile (=='\\') (reverse x) of
                  [] -> Parameters { directory = x ++ "\\" }
                  (_:_) -> Parameters { directory = x }

parseFile :: String -> (String, String)
parseFile x = case takeWhile (/='\\') (reverse x) of
                  [] -> ("", x)
                  xs -> (reverse xs, reverse $ drop (length xs) (reverse x))

parseFilters :: (Parameters, String) -> Maybe (Parameters, String)
parseFilters (p, xs) = Just (p { filters = fst fs }, snd fs)
    where fs = getSection xs

parseAction :: (Parameters, String) -> Maybe (Parameters, String)
parseAction (p, xs) = Just (p { actions = fst act }, snd act)
    where act = getSection xs

parseDir :: String -> Maybe (Parameters, String)
parseDir xs = Just (formatDir (fst dir), snd dir)
    where dir = getSection xs

getSection :: String -> (String, String)
getSection xs = (section, drop (length section + 1) xs)
    where section = takeWhile (/=' ') xs

parseParameters :: String -> Maybe (Parameters, String)
parseParameters xs = parseDir xs >>= parseAction >>= parseFilters




-- -hs-watcher "C:\Desenv" "textAction arquivoAlterado!" -ed node_modules bower_components -ef readme.md -only-ext hs