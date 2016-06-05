module Input.Parsers where

class Parameters a where
    addOption :: (Parameters a) => a -> String -> [String] -> Either String a
    firstOption :: (Parameters a) => (a, [String]) -> Either String (a, [String])
    validate :: (Parameters a) => a -> Either String a

parseParameters :: (Parameters a) => a  -> [String] -> Either String a
parseParameters params xs = parseHelp (params, xs) >>= firstOption >>= parseOptions >>= validate

-- Levemente Tricky essa implementação. No caso de erro, o texto de ajuda sempre é impresso pelo módulo Main,
-- portanto, não preciso me preocupar em chamar o módulo de impressão de ajuda aqui, retornando apenas um Left.
parseHelp :: (Parameters a) =>  (a, [String]) -> Either String (a, [String])
parseHelp (p, xs) = if "--help" `elem` xs
                        then Left ""
                        else Right (p, xs)

parseOptions :: (Parameters a) => (a, [String]) -> Either String a
parseOptions (p, []) = Right p
parseOptions (p, x:xs) = case addOption p x options of
    Right params -> parseOptions (params, drop (length options) xs)
    Left msg -> Left msg
    where options = takeOptions xs

takeOptions :: [String] -> [String]
takeOptions = takeWhile ((/='-') . head)

