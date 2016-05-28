module Parameters.Parsers where

import Parameters.Parameters
import Arquivo.Filter
import Actions.Action

import Data.List
import Data.Maybe (isNothing, isJust, fromJust)

parseParameters :: [String] -> Maybe (Parameters, [String])
parseParameters xs = parseDir (emptyParams, xs) >>= parseOptions

parseDir :: (Parameters, [String]) -> Maybe (Parameters, [String])
parseDir (p, x:xs)
    | head x == '-' = Just (p { directory = "." }, x:xs)
    | otherwise = Just (p { directory = formatDir x }, xs)

formatDir :: String -> String
formatDir x = case takeWhile (=='\\') (reverse x) of
                  [] -> x ++ "\\"
                  (_:_) -> x

parseOptions :: (Parameters, [String]) -> Maybe (Parameters, [String])
parseOptions (p, []) = Just (p, [])
parseOptions (p, x:xs)
    | isJust a = parseOptions (p{actions = fromJust a options : actions p }, drop (length options) xs)
    | isJust f = parseOptions (p{filters = fromJust f options : filters p }, drop (length options) xs)
    | otherwise = Nothing
    where a = keyMatch x actionsList
          f = keyMatch x filtersList
          options = takeOptions xs

parseFile :: String -> (String, String)
parseFile x = case takeWhile (/='\\') (reverse x) of
                  [] -> ("", x)
                  xs -> (reverse xs, reverse $ drop (length xs) (reverse x))

takeOptions :: [String] -> [String]
takeOptions = takeWhile ((/='-') . head)

keyMatch :: String -> [([String], [String] -> a)] -> Maybe ([String] -> a)
keyMatch _ [] = Nothing
keyMatch op (f:fs) = if op `elem` fst f then Just (snd f) else keyMatch op fs

filtersList :: [([String], [String] -> Filter)]
filtersList = [(["--ed", "--exclude-directories"], excludeDirectories)
              ,(["--ef", "--exclude-files"], excludeFiles)
              ,(["--exts", "--only-extensions"], onlyExtensions)]

actionsList :: [([String], [String] -> Action)]
actionsList = [(["--p", "--print"], textAction)
              ,(["--cmd", "--command"], cmdAction)]