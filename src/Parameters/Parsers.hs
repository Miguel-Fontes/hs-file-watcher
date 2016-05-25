module Parameters.Parsers where

import Parameters.Parameters
import Arquivo.Filter
import Action

import Data.List
import Data.Maybe (isNothing, fromJust)

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
    | isNothing f = Nothing
    | otherwise = parseFilters (p{filters = fromJust f options : filters p}, drop (length options) xs)
    where f = keyMatch x filtersList
          options = takeOptions xs

parseAction :: (Parameters, [String]) -> Maybe (Parameters, [String])
parseAction (p, []) = Just (p, [])
parseAction (p, x:xs)
    | isNothing f = Just (p, x:xs)
    | otherwise = parseAction (p{actions = fromJust f options : actions p }, drop (length options) xs)
    where f = keyMatch x actionsList
          options = takeOptions xs

parseDir :: (Parameters, [String]) -> Maybe (Parameters, [String])
parseDir (p, x:xs) = Just (p { directory = formatDir x }, xs)

parseParameters :: [String] -> Maybe (Parameters, [String])
parseParameters xs = parseDir (emptyParams, xs) >>= parseAction >>= parseFilters

takeOptions :: [String] -> [String]
takeOptions = takeWhile ((/='-') . head)

filtersList :: [([String], [String] -> Filter)]
filtersList = [(["--ed", "--exclude-directories"], excludeDirectories)
              ,(["--ef", "--exclude-files"], excludeFiles)
              ,(["--exts", "--only-exts"], onlyExtensions)]

actionsList :: [([String], [String] -> Action)]
actionsList = [(["--p", "--print"], textAction)]

keyMatch :: String -> [([String], [String] -> a)] -> Maybe ([String] -> a)
keyMatch _ [] = Nothing
keyMatch op (f:fs) = if op `elem` fst f then Just (snd f) else keyMatch op fs