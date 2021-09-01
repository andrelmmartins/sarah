module Utils where

import Data.Text as T
import Data.List as L

toUpperCaseAndStrip:: String -> String
toUpperCaseAndStrip text = T.unpack (T.strip (T.toUpper (T.pack text)))

contains:: String -> String -> Bool 
contains string parte = isSubsequenceOf parte string

trimAllBlankSpaces:: String -> String 
trimAllBlankSpaces text = T.unpack (T.strip (T.filter (/= ' ') (T.pack text)))

unSplit :: [String] -> String
unSplit [] = ""
unSplit  lista  
    | L.length lista == 1 = L.head lista
    | otherwise = L.head lista ++ "," ++ unSplit (L.tail lista)

wordsWhen     :: (Char -> Bool) -> String -> [String]
wordsWhen p s =  case L.dropWhile p s of
                      "" -> []
                      s' -> w : wordsWhen p s''
                            where (w, s'') = L.break p s'
