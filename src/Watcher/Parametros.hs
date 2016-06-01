module Watcher.Parametros where

import Watcher.Arquivo
import Watcher.Filter
import Watcher.Action

import Command.Command

import Data.List
import Data.Maybe (isNothing, isJust, fromJust)
import Input.Parsers

data Parametros = Parametros { directory :: FilePath
                              ,actions   :: [Action Arquivo]
                              ,filters   :: [Filter] }

instance Show Parametros where
    show (Parametros d a f) = "Dir: " ++ d ++ " - Actions: " ++ show a ++  " - Filters: " ++ show f

instance Eq Parametros where
    Parametros d1 a1 f1 == Parametros d2 a2 f2 = d1 == d2 && a1 == a2 && f1 == f2

instance Parameters Parametros where
    firstOption = parseDir
    addOption = addOption'
    validate = validate'

emptyParams :: Parametros
emptyParams = Parametros {directory = "", actions = [], filters = []}

-- Rever implementação abaixo.
addAction :: Parametros -> ([String] -> Action Arquivo) -> [String] -> Parametros
addAction p a args = p { actions =  actions p ++ [a args] }

addFilter :: Parametros -> ([String] -> Filter) -> [String] -> Parametros
addFilter p f args = p { filters = filters p ++ [f args] }

keyMatch :: String -> [(Option, [String] -> a)] -> Maybe ([String] -> a)
keyMatch _ [] = Nothing
keyMatch op (f:fs) = if op `elem` getKey (fst f) then Just (snd f) else keyMatch op fs

addOption' :: Parametros -> String -> [String] -> Either String Parametros
addOption' p k ks
    | isJust a = Right $ addAction p (fromJust a) ks
    | isJust f = Right $ addFilter p (fromJust f) ks
    | otherwise = Left ("O comando \'" ++ k ++ "\' nao existe!")
    where a = keyMatch k actionsList
          f = keyMatch k filtersList

validate' :: Parametros -> Either String Parametros
validate' p
    | null (actions p) = Left "Não foram definidas acões!"
    | directory p == "" = Left "Diretorio não definido!"
    | otherwise = Right p

parseDir :: (Parametros, [String]) -> Either String (Parametros, [String])
parseDir (p, x:xs)
    | head x == '-' = Right (p { directory = "." }, x:xs)
    | otherwise = Right (p { directory = formatDir x }, xs)

formatDir :: String -> String
formatDir x = case takeWhile (=='\\') (reverse x) of
                  [] -> x ++ "\\"
                  (_:_) -> x

parseFile :: String -> (String, String)
parseFile x = case takeWhile (/='\\') (reverse x) of
                  [] -> ("", x)
                  xs -> (reverse xs, reverse $ drop (length xs) (reverse x))