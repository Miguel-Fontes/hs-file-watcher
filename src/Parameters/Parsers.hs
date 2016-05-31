module Parameters.Parsers where

import Parameters.Parameters
import Watcher.Filter
import Watcher.Action
import Comando.Comando

import Data.List
import Data.Maybe (isNothing, isJust, fromJust)

parseParameters :: [String] -> Either String Parameters
parseParameters xs = parseHelp (emptyParams, xs) >>= parseDir >>= parseOptions >>= validateParameters

-- Levemente Tricky essa implementação. No caso de erro, o texto de ajuda sempre é impresso pelo módulo Main,
-- portanto, não preciso me preocupar em chamar o módulo de impressão de ajuda aqui, retornando apenas um Left.
parseHelp :: (Parameters, [String]) -> Either String (Parameters, [String])
parseHelp (p, xs) = if "--help" `elem` xs
                        then Left ""
                        else Right (p, xs)

parseDir :: (Parameters, [String]) -> Either String (Parameters, [String])
parseDir (p, x:xs)
    | head x == '-' = Right (p { directory = "." }, x:xs)
    | otherwise = Right (p { directory = formatDir x }, xs)

formatDir :: String -> String
formatDir x = case takeWhile (=='\\') (reverse x) of
                  [] -> x ++ "\\"
                  (_:_) -> x

parseOptions :: (Parameters, [String]) -> Either String Parameters
parseOptions (p, []) = Right $ p { actions = reverse (actions p), filters = reverse (filters p) }
parseOptions (p, x:xs)
    | isJust a = parseOptions (p{actions = fromJust a options : actions p }, drop (length options) xs)
    | isJust f = parseOptions (p{filters = fromJust f options : filters p }, drop (length options) xs)
    | otherwise = Left ("O comando \'" ++ x ++ "\' nao existe!")
    where a = keyMatch x actionsList
          f = keyMatch x filtersList
          options = takeOptions xs

parseFile :: String -> (String, String)
parseFile x = case takeWhile (/='\\') (reverse x) of
                  [] -> ("", x)
                  xs -> (reverse xs, reverse $ drop (length xs) (reverse x))

validateParameters :: Parameters -> Either String Parameters
validateParameters p
    | null (actions p) = Left "Não foram definidas acões!"
    | directory p == "" = Left "Diretorio não definido!"
    | otherwise = Right p

takeOptions :: [String] -> [String]
takeOptions = takeWhile ((/='-') . head)

keyMatch :: String -> [(Option, [String] -> a)] -> Maybe ([String] -> a)
keyMatch _ [] = Nothing
keyMatch op (f:fs) = if op `elem` getKey (fst f) then Just (snd f) else keyMatch op fs

