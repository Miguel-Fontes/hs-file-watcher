module Parameters.Parameters where

import Arquivo.Filter
import Action

data Parameters = Parameters { directory :: FilePath
                              ,actions   :: [Action]
                              ,filters   :: [Filter] }


emptyParams = Parameters {directory = "", actions = [], filters = []}

instance Show Parameters where
    show (Parameters d a f) = show ("Dir: " ++ d ++ " - Actions: " ++ show a ++  " - Filters: " ++ show f)