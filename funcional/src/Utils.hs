module Utils where

import Data.Text as T
import Data.List as L

toUpperCaseAndStrip:: String -> String
toUpperCaseAndStrip text = T.unpack (T.strip (T.toUpper (T.pack text)))

contains:: String -> String -> Bool 
contains string parte = isSubsequenceOf parte string

trimAllBlankSpaces:: String -> String 
trimAllBlankSpaces text = T.unpack (T.strip (T.filter (/= ' ') (T.pack text)))