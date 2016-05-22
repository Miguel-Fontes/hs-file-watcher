module Arquivo.Watch where

import Data.Time
import System.Directory
import Control.Monad
import Control.Concurrent (threadDelay)

import Action
import Arquivo.Filter
import Arquivo.Arquivo

watch :: [Arquivo] -> Action -> Int -> IO()
watch ultLista action delay = do
    threadDelay delay
    print "-- Iteracao -----------------------------------------------------------------------------"

    peek  "--> ultLista" ultLista
    lista <- listaArquivos "." >>= peek "--> Lista"

    if lista /= ultLista
        then exec action () >> watch lista action delay
        else watch lista action delay

getLastModified :: [FilePath] -> [String] -> IO [String]
getLastModified (f:fs) m = do
    time <- fmap (formatTime defaultTimeLocale "%d/%m/%Y %T") (getModificationTime f)
    if not $ null fs
        then getLastModified fs (time : m)
        else return $ reverse (time : m)

listaArquivos :: String -> IO [Arquivo]
listaArquivos dir = do
    files <- getDirectoryContents dir
    modification <- getLastModified files []
    return $ applyFilter noPoints (zipWith3 Arquivo files modification (repeat dir))

peek :: String -> [Arquivo] -> IO [Arquivo]
peek name fl = do
    when (name /= "") $ print name
    print fl
    return fl