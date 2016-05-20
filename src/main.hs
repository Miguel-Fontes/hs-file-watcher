import Control.Monad
import Data.Maybe
import Data.Time
import System.Directory
import System.IO
import Control.Concurrent (threadDelay)
import Control.DeepSeq

type Arquivo = (String, String)

getLastModified :: FilePath -> IO String
getLastModified x = do
    time <- fmap (formatTime defaultTimeLocale "%d/%m/%Y %T") (getModificationTime x)
    return time


getLastModified' :: [FilePath] -> [String] -> IO [String]
getLastModified' (f:fs) m = do
    time <- fmap (formatTime defaultTimeLocale "%d/%m/%Y %T") (getModificationTime f)
    if (length fs > 0)
        then getLastModified' fs (time : m)
        else return (time : m)



compareFileLists :: [(FilePath, IO String)] -> [(FilePath, IO String)] -> IO Bool
compareFileLists [] _ = return False -- Checamos todos, nenhum mudou
compareFileLists (l:[]) ul = fileChanged l ul -- Ultimo arquivo
compareFileLists (l:ls) ul
    | isNothing $ lookup (fst l) ul = return True -- Arquivo não existe, ou seja, e novo
    | otherwise = fileChanged l ul >>= (\changed -> if changed then return changed else compareFileLists ls ul)

fileChanged :: (FilePath, IO String) -> [(FilePath, IO String)] -> IO Bool
fileChanged l ul = do
    liftM2 (/=) (fromJust $ lookup (fst l) ul) (snd l)

peek :: (FilePath, IO String) -> IO String
peek fl = do
    file <- return $ fst fl
    time <- snd fl
    t <- return $ (file ++ " - " ++ time)
    print t
    return t

listaArquivos :: String -> IO [(FilePath, IO String)]
listaArquivos dir = do
    files <- getDirectoryContents dir
    let parseFiles = map (\x -> dir ++ "/" ++ x) . filter (/=".") . filter (/="..")
        parsedFilesList = parseFiles files
        modification = map getLastModified parsedFilesList
        fileMap = zip parsedFilesList modification
    return fileMap

watch :: [(FilePath, IO String)] -> IO()
watch ultLista = do

    print "--> Ult Lista"
    n <- return $ map peek ultLista
    a1 <- last n
    a2 <- head n

    threadDelay 3000000 -- Sem isso esse programa é um completo psicopata
    print "------------------------------------------------------"

    lista <- listaArquivos "."

    print "--> Lista"
    b <- return $ map peek lista
    b1 <- last b
    b2 <- head b

    print $ (==) b2 a2

    changed <- compareFileLists lista ultLista
    if changed then print "Teve treta" else watch lista

main :: IO()
main  = do
    lista <- listaArquivos "."
    watch lista
    print "Complete!"