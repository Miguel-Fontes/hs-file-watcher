module Watcher.Watch (watch) where

import Data.Time
import System.Directory
import Control.Monad
import Data.List
import Control.Concurrent (threadDelay)

import Watcher.Action
import Watcher.Filter
import Watcher.Arquivo
import Utils.IOFold

watch :: [Filter] -> FilePath  -> [Action Arquivo] -> Int -> IO()
watch filters dir actions delay = do
    directory <- if dir == "."
                     then fmap (++ "\\") getCurrentDirectory
                     else return dir

    putStrLn ("-> Monitorando o diretório " ++ directory ++ ".")
    putStrLn "-> Pressione CTRL+C à qualquer momento para interrompeter a execução.....\n"

    lista <- listaArquivos filters directory

    watchFiles filters directory lista actions delay

watchFiles :: [Filter] -> FilePath  -> [Arquivo] -> [Action Arquivo] -> Int -> IO()
watchFiles filters dir ultLista actions delay = do
    threadDelay delay

    lista <- listaArquivos filters dir

    if lista /= ultLista
        then putStrLn "-> Mudanças identificadas..." >>
             mapM_ (`exec` (ultLista \\ lista)) actions >>
             watchFiles filters dir lista actions delay
        else watchFiles filters dir lista actions delay

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
    when (name /= "") $ putStrLn name
    print fl
    return fl