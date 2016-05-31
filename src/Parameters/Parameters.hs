module Parameters.Parameters (
      emptyParams
    , Parameters (directory, actions, filters)
) where

import Watch.Arquivo
import Watch.Filter
import Watch.Action

data Parameters = Parameters { directory :: FilePath
                              ,actions   :: [Action Arquivo]
                              ,filters   :: [Filter] }


emptyParams = Parameters {directory = "", actions = [], filters = []}

instance Show Parameters where
    show (Parameters d a f) = "Dir: " ++ d ++ " - Actions: " ++ show a ++  " - Filters: " ++ show f

instance Eq Parameters where
    Parameters d1 a1 f1 == Parameters d2 a2 f2 = d1 == d2 && a1 == a2 && f1 == f2