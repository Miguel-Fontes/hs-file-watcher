module Parameters.Parameters where

import Arquivo.Filter
import Action

data Parameters = Parameters { directory :: FilePath
                              ,actions   :: String
                              ,filters   :: [Filter] }


emptyParams = Parameters {directory = "", actions = "", filters = []}

instance Show Parameters where
    show (Parameters d a f) = show (d ++ " - " ++ a ++ " - " )