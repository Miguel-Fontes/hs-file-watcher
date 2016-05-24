module Parameters.Parameters where

import Arquivo.Filter
import Action

data Parameters = Parameters {
    directory :: String,
    action :: [Action],
    filters :: [Filter]
}

