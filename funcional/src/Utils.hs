module Utils where

import Data.Text as T

toUpperCase:: String -> String
toUpperCase text = T.unpack (T.toUpper (T.pack text))