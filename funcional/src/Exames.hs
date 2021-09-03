module Exames where

import Text.Read (Read)
import System.IO
    ( hClose,
      openFile,
      hGetContents,
      hPutStr,
      openTempFile,
      IOMode(ReadMode) )
import System.Directory
    ( getTemporaryDirectory, removeFile, renameFile )
import qualified Data.Text as T
import qualified Data.List as L

import Utils ( toUpperCaseAndStrip, contains, trimAllBlankSpaces )

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
examesToString (e:es) = if not (null es) then do "["++exameToString e ++"]\n" ++ examesToString es
    else do "[" ++ exameToString e ++ "]\n"

criarExame:: String -> Double -> Exame
criarExame nome valor = Exame{nome = nome, valor = valor}

-- funcao para adicionar exames internamente
addExame:: String -> Double -> IO()
addExame nome valor = addToTxt(criarExame nome valor)

addToTxt::Exames.Exame -> IO()
addToTxt exame = do
    appendFile "../db/exames.txt" (Exames.nome exame ++ ", " ++ show (Exames.valor exame) ++ "\n")
    return ()

getAllExames ::  IO()
getAllExames  = do
    handle <- openFile "../db/exames.txt" ReadMode  
    conteudo <- hGetContents handle
    let examesString = map T.unpack (T.splitOn (T.pack "\n") (T.pack conteudo))
    let exames = map formatExameToShow (filter (not . null) examesString)
    putStr (examesToString exames)
    hClose handle

findExamePeloNome:: String -> IO()
findExamePeloNome nome = do
  exames <- readFile "../db/exames.txt"
  let examesList = T.splitOn (T.pack "\n") (T.pack exames)
  let foundedExam = findExamePeloNomeRec nome examesList 0
  if (foundedExam /= "Exame nao encontrado.") then print (exameToString(formatExameToShow foundedExam))
  else print foundedExam

findExamePeloNomeRec:: String -> [T.Text] -> Int -> String
findExamePeloNomeRec nome examesList indice  
  | indice >= length examesList = "Exame nao encontrado."
  | toUpperCaseAndStrip (trimAllBlankSpaces nome) == toUpperCaseAndStrip (getNomeDoExame exame) = T.unpack exame
  | otherwise = findExamePeloNomeRec nome examesList (indice+1)
  where
    exame = examesList !! indice

formatExameToShow:: String -> Exame
formatExameToShow exame = criarExame (getNomeDoExame exameText) (getValorDoExame exameText)
  where 
    exameText = T.pack exame

getNomeDoExame:: T.Text -> String
getNomeDoExame exame = T.unpack (head (T.splitOn (T.pack ", ") exame))

getValorDoExame:: T.Text -> Double
getValorDoExame exame = read (T.unpack (T.splitOn (T.pack ", ") exame !! 1))

removerExamePeloNome:: String -> IO()
removerExamePeloNome nome = do
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

--------------------- Menus de Exames -------------------------
menuBuscaExamePeloNome:: IO()
menuBuscaExamePeloNome = do
    putStrLn "Informe o nome do exame que deseja encontrar:"
    nome <- getLine
    findExamePeloNome (nome++"\n")

menuEditarExamePeloNome:: IO()
menuEditarExamePeloNome = do
    putStrLn "Informe o nome do exame a ser editado:"
    nome <- getLine
    putStrLn "Informe o novo nome desse exame:"
    novoNome <- getLine
    putStrLn "Informe o novo valor desse exame:"
    novoValor <- getLine
    removerExamePeloNome nome
    addExame novoNome (read novoValor)
    putStrLn "Exame editado com sucesso."

menuRemoverExamePeloNome:: IO()
menuRemoverExamePeloNome = do
    putStrLn "Informe o nome do exame a ser removido:"
    nome <- getLine
    removerExamePeloNome nome
    putStrLn "Exame removido com sucesso."

menuAddExame:: IO()
menuAddExame = do
    putStrLn "Informe o nome do exame a ser adicionado:"
    nome <- getLine
    putStrLn "Informe o valor desse exame:"
    valor <- getLine
    addExame nome (read valor)
    print "Exame adicionado com sucesso."
