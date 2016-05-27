module Arquivo.Watch where

import Data.Time
import System.Directory
import Control.Monad
import Data.List
import Control.Concurrent (threadDelay)

import Actions.Action
import Arquivo.Filter
import Arquivo.Arquivo
import Utils.IOFold

watch :: [Filter] -> FilePath  -> [Arquivo] -> [Action] -> Int -> IO()
watch filters dir ultLista actions delay = do
    threadDelay delay
    print "-- Iteracao -----------------------------------------------------------------------------"

    peek  "--> ultLista" ultLista
    lista <- listaArquivos filters dir >>= peek "--> Lista"

    if lista /= ultLista
        then mapM_ (`exec` ()) actions >> watch filters dir lista actions delay
        else watch filters dir lista actions delay

listaArquivos :: [Filter] -> FilePath -> IO [Arquivo]
listaArquivos filters dir = do
    setCurrentDirectory dir
    files <- getDirectoryContents dir
    modification <- getLastModified files
    isDirectory <- getDirectories files
    let parsedFiles = applyFilters (noPoints : filters)
                      $ zipWith4 Arquivo files modification (repeat dir) isDirectory
    recurseSubdirectories filters parsedFiles

getDirectories :: [FilePath] -> IO [Bool]
getDirectories = ioFoldr doesDirectoryExist []

getLastModified :: [FilePath] -> IO [String]
getLastModified = ioFoldr (fmap (formatTime defaultTimeLocale "%d/%m/%Y %T") . getModificationTime) []

recurseSubdirectories :: [Filter] -> [Arquivo] -> IO [Arquivo]
recurseSubdirectories filters = ioFoldr' step []
   where step x = if isDirectory x then listaArquivos filters (dir x ++ nome x ++ "\\") else return [x]

peek :: String -> [Arquivo] -> IO [Arquivo]
peek name fl = do
    when (name /= "") $ print name
    print fl
    return fl