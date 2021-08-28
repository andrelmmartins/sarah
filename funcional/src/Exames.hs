module Exame where

import Text.Read (Read)
import System.IO
import qualified Data.Text as T
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
  | toUpperCase nome == toUpperCase (getNomeDoExame exame) = T.unpack(exame)
  | otherwise = findExamePeloNomeRec nome array (indice+1)
  where
    exame = array !! indice

getNomeDoExame:: T.Text -> String
getNomeDoExame exame = T.unpack ((T.splitOn (T.pack ", ") (exame)) !! 0)

-- funcao apenas para testes sem precisar compilar
add:: String -> Double -> IO()
add nome valor = addExame(criarExame nome valor)

-- getExamePeloNome:: String -> [Exame]
-- getExamePeloNome nome = getAllExames 


-- getNomeDoExame:: Exame -> String
-- getNomeDoExame Exame { nome = n } = n

-- getValorDoExame:: Exame -> Double
-- getValorDoExame Exame { valor = p } = p

-- getExamePeloNome :: String -> [Exame] -> Maybe Exame
-- getExamePeloNome id [] = Nothing
-- getExamePeloNome id (p:ps) = if id == getNomeDoExame p then Just p
--     else getExamePeloNome id ps

-- setValor :: [Exame] -> String -> Double -> [Exame]
-- setValor [] nome novoPreco = []
-- setValor (c:cs) nome novoPreco
--     | nomeAtual == nome = Exame nome novoPreco : cs
--     | otherwise = setValor cs nome novoPreco
--     where
--         nomeAtual = getNomeDoExame c