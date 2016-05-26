module Parameters.Parameters where

import Arquivo.Filter
import Actions.Action

data Parameters = Parameters { directory :: FilePath
                              ,actions   :: [Action]
                              ,filters   :: [Filter] }


emptyParams = Parameters {directory = "", actions = [], filters = []}

instance Show Parameters where
    show (Parameters d a f) = "Dir: " ++ d ++ " - Actions: " ++ show a ++  " - Filters: " ++ show f