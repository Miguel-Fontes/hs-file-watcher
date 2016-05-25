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
    | x == "--ed" = let dirs = takeOptions xs
                     in parseFilters (p{filters = excludeDirectories dirs : filters p}, drop (length dirs) xs)
    | x == "--only-ext" = let ext = takeOptions xs
                           in parseFilters (p{filters = onlyExtensions ext : filters p}, drop 1 xs)
    | x == "--ef" = let files = takeOptions xs
                     in parseFilters (p{filters = excludeFiles files : filters p}, drop (length files) xs)
    | otherwise = Nothing

parseAction :: (Parameters, [String]) -> Maybe (Parameters, [String])
parseAction (p, []) = Just (p, [])
parseAction (p, x:xs)
    | x == "--print" = let text = head xs
                        in parseAction (p{actions = textAction text : actions p }, drop 1 xs)
    | otherwise = Just (p, x:xs)

parseDir :: (Parameters, [String]) -> Maybe (Parameters, [String])
parseDir (p, x:xs) = Just (p { directory = formatDir x }, xs)

getSection :: String -> (String, String)
getSection xs = (section, drop (length section + 1) xs)
    where section = takeWhile (/=' ') xs

parseParameters :: [String] -> Maybe (Parameters, [String])
parseParameters xs = parseDir (emptyParams, xs) >>= parseAction >>= parseFilters

takeOptions :: [String] -> [String]
takeOptions = takeWhile ((/='-') . head)
{-
--ed --exclude-directory excludeDirectories
--ef --exclude-file excludeDirectories
--ext --only-ext onlyExtension
(["--ed", "--exclude-directoy"], excludeDirectory])

-}