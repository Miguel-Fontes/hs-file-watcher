module Parameters.Parsers where

import Parameters.Parameters
import Arquivo.Filter
import Action

parseDir :: String -> String
parseDir x = case takeWhile (=='\\') (reverse x) of
                  [] -> x ++ "\\"
                  (_:_) -> x

parseFile :: String -> (String, String)
parseFile x = case takeWhile (/='\\') (reverse x) of
                  [] -> ("", x)
                  xs -> (reverse xs, reverse $ drop (length xs) (reverse x))

parseFilter :: String -> Filter
parseFilter = excludeDirectories . words

parseAction :: String -> Action
parseAction = undefined

parseParameters :: String -> String
parseParameters = undefined

getSection :: String -> (String, String)
getSection xs = (section, drop (length section + 1) xs)
    where section = takeWhile (/=' ') xs




-- -hs-watcher "C:\Desenv" "textAction arquivoAlterado!" -ed node_modules bower_components -ef readme.md -only-ext hs