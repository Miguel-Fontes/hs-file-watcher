module Arquivo.Watch where

import Data.Time
import System.Directory
import Control.Monad
import Data.List
import Control.Concurrent (threadDelay)

import Action
import Arquivo.Filter
import Arquivo.Arquivo
import Utils.IOFold

watch :: FilePath -> [Arquivo] -> Action -> Int -> IO()
watch dir ultLista action delay = do
    threadDelay delay
    print "-- Iteracao -----------------------------------------------------------------------------"

    peek  "--> ultLista" ultLista
    lista <- listaArquivos dir >>= peek "--> Lista"

    if lista /= ultLista
        then exec action () >> watch dir lista action delay
        else watch dir lista action delay

listaArquivos :: FilePath -> IO [Arquivo]
listaArquivos dir = do
    setCurrentDirectory dir
    files <- getDirectoryContents dir
    modification <- getLastModified files
    isDirectory <- getDirectories files
    let parsedFiles = applyFilters [noPoints, excludeDirectories ["node_modules", ".git", "bower_components"]]
                      $ zipWith4 Arquivo files modification (repeat dir) isDirectory
    recurseSubdirectories parsedFiles

getDirectories :: [FilePath] -> IO [Bool]
getDirectories = ioFoldr doesDirectoryExist []

getLastModified :: [FilePath] -> IO [String]
getLastModified = ioFoldr (fmap (formatTime defaultTimeLocale "%d/%m/%Y %T") . getModificationTime) []

recurseSubdirectories :: [Arquivo] -> IO [Arquivo]
recurseSubdirectories = ioFoldr' step []
   where step x = if isDirectory x then listaArquivos (dir x ++ nome x ++ "\\") else return [x]

peek :: String -> [Arquivo] -> IO [Arquivo]
peek name fl = do
    when (name /= "") $ print name
    print fl
    return fl