import Control.Monad
import Data.Maybe
import Data.Time
import System.Directory
import System.IO
import Control.Concurrent (threadDelay)

data Arquivo = Arquivo {
    nome :: String,
    modificado :: String
}

instance Show Arquivo where
    show (Arquivo n m) = "Arquivo: " ++ n ++ " - " ++ m

instance Eq Arquivo where
    (Arquivo n1 m1) == (Arquivo n2 m2) = (n1 == n2) && (m1 == m2)

getLastModified :: [FilePath] -> [String] -> IO [String]
getLastModified (f:fs) m = do
    time <- fmap (formatTime defaultTimeLocale "%d/%m/%Y %T") (getModificationTime f)
    if not $ null fs
        then getLastModified fs (time : m)
        else return $ reverse (time : m)

peek :: String -> [Arquivo] -> IO [Arquivo]
peek name fl = do
    when (name /= "") $ print name
    print fl
    return fl

listaArquivos :: String -> IO [Arquivo]
listaArquivos dir = do
    files <-  map (\x -> dir ++ "/" ++ x) . filter (\x -> x /= "." && x /="..")  <$> getDirectoryContents dir
    modification <- getLastModified files []
    return $ zipWith Arquivo files modification

watch :: [Arquivo] -> (() -> IO()) -> Int -> IO()
watch ultLista action delay = do
    threadDelay delay
    print "-- Iteracao -----------------------------------------------------------------------------"

    peek  "--> ultLista" ultLista
    lista <- listaArquivos "." >>= peek "--> Lista"

    if lista /= ultLista
        then action () >> watch lista action delay
        else watch lista action delay

main :: IO()
main  = do
    lista <- listaArquivos "."
    watch lista (\() -> print "############# ARQUIVOS ALTERADOS! ################") 3000000
    print "Complete!"