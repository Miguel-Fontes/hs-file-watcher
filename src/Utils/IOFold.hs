module Utils.IOFold where

ioFoldl :: (a -> IO b) -> [b] -> [a] -> IO [b]
ioFoldl _ l [] = return l
ioFoldl f l (x:xs) = do
    i <- f x
    if not $ null xs
        then ioFoldl f (i:l) xs
        else return (i:l)

-- Esta implementação tem de ser revista
ioFoldr :: (a -> IO b) -> [b] -> [a] -> IO [b]
ioFoldr f l xs = do
    result <- ioFoldl f l xs
    return $ reverse result

ioFoldl' :: (a -> IO [b]) -> [b] -> [a] -> IO [b]
ioFoldl' _ l [] = return l
ioFoldl' f l (x:xs) = do
    i <- f x
    if not $ null xs
        then ioFoldl' f (i++l) xs
        else return (i++l)

-- Esta implementação tem de ser revista
ioFoldr' :: (a -> IO [b]) -> [b] -> [a] -> IO [b]
ioFoldr' f l xs = do
    result <- ioFoldl' f l xs
    return $ reverse result