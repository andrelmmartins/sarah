module Exame where

import Text.Read (Read)
import System.IO
import System.Directory
import qualified Data.Text as T
import qualified Data.List as L
import Utils

data Exame = Exame{
    nome :: String,
    valor :: Double
} deriving (Show, Read)

newtype Exames = Exames {
   exames :: [(String, Exame)]
} deriving Show

exameToString:: Exame -> String
exameToString Exame { nome = n, valor = v } = n ++ ": R$ " ++ show v

examesToString :: [Exame] -> String
examesToString [] = []
examesToString (e:es) = if not (null es) then do "["++exameToString e ++"]," ++ examesToString es
    else do "[" ++ exameToString e ++ "]"

criarExame:: String -> Double -> Exame
criarExame nome valor = Exame{nome = nome, valor = valor}

addExame::Exame.Exame -> IO()
addExame exame = do
    appendFile "../db/exames.txt" (Exame.nome exame ++ ", " ++ show (Exame.valor exame) ++ "\n")
    return ()

getAllExames ::  IO()
getAllExames  = do
    handle <- openFile "../db/exames.txt" ReadMode  
    conteudo <- hGetContents handle
    putStr conteudo
    hClose handle

findExamePeloNome:: String -> IO()
findExamePeloNome nome = do
  exames <- readFile "../db/exames.txt"
  let array = T.splitOn (T.pack "\n") (T.pack exames)
  print (findExamePeloNomeRec nome array 0)

findExamePeloNomeRec:: String -> [T.Text] -> Int -> String
findExamePeloNomeRec nome array indice  
  | indice >= length array = "Exame nao encontrado."
  | toUpperCaseAndStrip (trimAllBlankSpaces nome) == toUpperCaseAndStrip (getNomeDoExame exame) = T.unpack exame
  | otherwise = findExamePeloNomeRec nome array (indice+1)
  where
    exame = array !! indice

getNomeDoExame:: T.Text -> String
getNomeDoExame exame = T.unpack (head (T.splitOn (T.pack ", ") exame))

removeExamePeloNome:: String -> IO()
removeExamePeloNome nome = do
    handle <- openFile "../db/exames.txt" ReadMode  
    tempdir <- getTemporaryDirectory  
    (tempName, tempHandle) <- openTempFile tempdir "temp"  
    contents <- hGetContents handle
    let listaComExames = lines contents
    let examesResultantes = filter (\x -> not (contains x (toUpperCaseAndStrip nome))) (map toUpperCaseAndStrip listaComExames)
    let examesFormatados = map (T.unpack . T.toTitle . T.pack) examesResultantes
    hPutStr tempHandle $ unlines examesFormatados  
    hClose handle  
    hClose tempHandle  
    removeFile "../db/exames.txt" 
    renameFile tempName "../db/exames.txt" 

add:: String -> Double -> IO()
add nome valor = addExame(criarExame nome valor)