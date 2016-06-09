module Utils.JSON where

import Data.List

class JSON a where
    jStringfy :: (JSON a) => a -> String
    jStringfyList :: (JSON a) => [a] -> String

toJSON :: [JParsable] -> String
toJSON = brackets . unwords . intersperse "," . foldr step []
    where step x acc = (toString x) : acc
          brackets x = "{" ++ x ++ "}"

data JParsable = JInt Int
               | JText String
               | JLabel String
               | JBool Bool
               | JGroup JParsable JParsable
     deriving (Show)

toString :: JParsable -> String
toString (JLabel l) = parsers l ++ ": "
toString (JInt x) = (parsers . show) x
toString (JBool b) = (parsers . show) b
toString (JText t) = parsers t
toString (JGroup l v) = toString l ++ toString v

parsers :: String -> String
parsers = quote . parseScape

quote :: String -> String
quote v = "\"" ++ v ++ "\""

parseScape :: String -> String
parseScape = foldr step ""
    where step x acc = if x == '\\' then "\\\\" ++ acc else x : acc 