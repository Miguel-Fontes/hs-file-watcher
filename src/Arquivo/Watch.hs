module Arquivo.Watch where

import Data.Time
import System.Directory
import Control.Monad
import Data.List
import Control.Concurrent (threadDelay)

import Action
import Arquivo.Filter
import Arquivo.Arquivo

watch :: FilePath -> [Arquivo] -> Action -> Int -> IO()
watch dir ultLista action delay = do
    threadDelay delay
    print "-- Iteracao -----------------------------------------------------------------------------"

    peek  "--> ultLista" ultLista
    lista <- listaArquivos dir >>= peek "--> Lista"

    if lista /= ultLista
        then exec action () >> watch dir lista action delay
        else watch dir lista action delay

getLastModified :: [FilePath] -> [String] -> IO [String]
getLastModified (f:fs) m = do
    time <- fmap (formatTime defaultTimeLocale "%d/%m/%Y %T") (getModificationTime f)
    if not $ null fs
        then getLastModified fs (time : m)
        else return $ reverse (time : m)

listaArquivos :: FilePath -> IO [Arquivo]
listaArquivos dir = do
    setCurrentDirectory dir
    files <- getDirectoryContents dir
    modification <- getLastModified files []
    isDirectory <- getDirectories files []
    let parsedFiles = applyFilters [noPoints, excludeDirectories ["node_modules", ".git"]]
                      $ zipWith4 Arquivo files modification (repeat dir) isDirectory
    recurseSubdirectories parsedFiles []

recurseSubdirectories :: [Arquivo] -> [Arquivo] -> IO [Arquivo]
recurseSubdirectories [] m = return m
recurseSubdirectories (f:fs) m = do
    arquivos <- if isDirectory f then listaArquivos (dir f ++ nome f ++ "\\") else return [f]
    if not $ null fs
        then recurseSubdirectories fs (arquivos ++ m)
        else return $ reverse (arquivos ++  m)

getDirectories :: [FilePath] -> [Bool] -> IO [Bool]
getDirectories (f:fs) m = do
    isDir <- doesDirectoryExist f
    if not $ null fs
        then getDirectories fs (isDir : m)
        else return $ reverse (isDir : m)

peek :: String -> [Arquivo] -> IO [Arquivo]
peek name fl = do
    when (name /= "") $ print name
    print fl
    return fl