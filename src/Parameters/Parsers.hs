module Parameters.Parsers where

import Parameters.Parameters
import Arquivo.Filter

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

parseParameters :: String -> Parameters
parseParameters xs = parseDir =>> parseAction =>> parseFilter

(=>>) :: (String -> (String, Parameter)) -> (String -> (String, Parameter)) -> (String, Parameter)




-- -hs-watcher "C:\Desenv" "textAction arquivoAlterado!" -ed node_modules bower_components -ef readme.md -only-ext hs