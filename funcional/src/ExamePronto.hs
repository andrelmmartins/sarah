module ExamePronto where

-- Imports
import Text.Read (Read)
import System.IO
import System.Directory
import qualified Data.Text as T
import qualified Data.List as L
import Data.Typeable

-- Construtor
data ExamePronto = ExamePronto {
    codigo :: String,
    senha :: String,
    link :: String
} deriving (Show, Read)

---------------------------Cadastrar um Exame Pronto----------------------------

cadastrarExamePronto:: String -> String -> String -> IO()
cadastrarExamePronto codigo senha link = adicionaExameProntoNoTxt(ExamePronto{codigo = codigo, senha = (codificaString senha), link = link})

adicionaExameProntoNoTxt::ExamePronto.ExamePronto -> IO()
adicionaExameProntoNoTxt examePronto = do
    appendFile "../db/examesProntos.txt" (ExamePronto.codigo examePronto ++ ", " ++ (ExamePronto.senha examePronto) ++ ", " ++ (ExamePronto.link examePronto) ++ "\n")
    return ()

---------------------------Buscar um Exame Pronto----------------------------

buscaExamePronto:: String -> IO()
buscaExamePronto codigoDado = do
    examesProntos <- readFile "../db/examesProntos.txt"
    let listaQuebrada = T.splitOn (T.pack "\n") (T.pack examesProntos)
    let listaConvertida = [toExamePronto (T.unpack exame) | exame <- listaQuebrada]
    print [exame | exame <- listaConvertida, codigo exame == codigoDado]

----------------------------Listar Exames Prontos---------------------------

listarExamesProntos :: IO()
listarExamesProntos = do
    handle <- openFile "../db/examesProntos.txt" ReadMode  
    conteudo <- hGetContents handle
    let listaQuebrada = T.splitOn (T.pack "\n") (T.pack conteudo)
    let listaConvertida = [ toExamePronto (T.unpack exame) | exame <- listaQuebrada]
    putStr (listaToString listaConvertida)
    hClose handle

listaToString :: [ExamePronto] -> String
listaToString [] = []
listaToString (e:es) = if not (null es) then do "[ " ++ toString e ++ " ]\n" ++ listaToString es
    else do "[ " ++ toString e ++ " ]\n"

----------------------------Remover Exame Pronto---------------------------

removerExamePronto :: String -> IO()
removerExamePronto codigoDado = do
    handle <- openFile "../db/examesProntos.txt" ReadMode  
    tempdir <- getTemporaryDirectory  
    (tempName, tempHandle) <- openTempFile tempdir "temp"  
    contents <- hGetContents handle
    let listaComExames = lines contents
    let examesResultantes = [exame | exame <- listaComExames, (codigo (toExamePronto exame)) /= codigoDado]
    let examesFormatados = map (T.unpack . T.toTitle . T.pack) examesResultantes
    hPutStr tempHandle $ unlines examesFormatados  
    hClose handle  
    hClose tempHandle  
    removeFile "../db/examesProntos.txt" 
    renameFile tempName "../db/examesProntos.txt"

----------------------------Editar Exame Pronto---------------------------

editarExamePronto :: String -> String -> String -> String -> IO()
editarExamePronto codigo novoCodigo novaSenha novoLink = do
    removerExamePronto codigo
    cadastrarExamePronto novoCodigo novaSenha novoLink
    return ()
    
----------------------------Menus---------------------------

menuEditarExamePronto :: IO()
menuEditarExamePronto = do
    putStrLn "Informe o codigo do Exame Pronto a ser editado:"
    codigoDado <- getLine

    examesProntos <- readFile "../db/examesProntos.txt"
    let listaQuebrada = T.splitOn (T.pack "\n") (T.pack examesProntos)
    let listaConvertida = [toExamePronto (T.unpack exame) | exame <- listaQuebrada]
    let listaBuscandoCodigo = [exame | exame <- listaConvertida, codigo exame == codigoDado]

    if (length listaBuscandoCodigo == 0) then print ">> Nenhum exame encontrado com esse codigo"
    else do
        putStrLn "Informe o Novo Codigo do Exame Pronto a ser editado:"
        novoCodigo <- getLine

        examesProntos <- readFile "../db/examesProntos.txt"
        let listaQuebrada = T.splitOn (T.pack "\n") (T.pack examesProntos)
        let listaConvertida = [toExamePronto (T.unpack exame) | exame <- listaQuebrada]
        let listaBuscandoCodigo = [exame | exame <- listaConvertida, codigo exame == novoCodigo]

        if (codigoDado /= novoCodigo && length listaBuscandoCodigo > 0) then print ">> Ja existe um exame com esse codigo"
        else do
            putStrLn "Informe a nova senha de acesso do cliente:"
            novaSenha <- getLine
            putStrLn "Informe o novo link do resultado:"
            novoLink <- getLine
            editarExamePronto codigoDado novoCodigo novaSenha novoLink
            print ">> Exame editado com sucesso."

menuCadastrarExame :: IO()
menuCadastrarExame = do
    putStrLn "\nInforme o Codigo do Exame Pronto a ser cadastrado:"
    codigoDado <- getLine

    examesProntos <- readFile "../db/examesProntos.txt"
    let listaQuebrada = T.splitOn (T.pack "\n") (T.pack examesProntos)
    let listaConvertida = [toExamePronto (T.unpack exame) | exame <- listaQuebrada]
    let listaBuscandoCodigo = [exame | exame <- listaConvertida, codigo exame == codigoDado]

    if (length listaBuscandoCodigo > 0) then print ">> Ja existe um resultado com esse codigo"
    else do
        putStrLn "\nInforme a senha de acesso do cliente:"
        senha <- getLine
        putStrLn "\nInforme o link do resultado:"
        link <- getLine
        cadastrarExamePronto codigoDado senha link
        print ">> Exame adicionado com sucesso."

menuRemoverExame :: IO()
menuRemoverExame = do
    putStrLn "\nInforme o Codigo do Exame Pronto que deve ser removido:"
    codigoDado <- getLine

    examesProntos <- readFile "../db/examesProntos.txt"
    let listaQuebrada = T.splitOn (T.pack "\n") (T.pack examesProntos)
    let listaConvertida = [toExamePronto (T.unpack exame) | exame <- listaQuebrada]
    let listaBuscandoCodigo = [exame | exame <- listaConvertida, codigo exame == codigoDado]

    if (length listaBuscandoCodigo == 0) then print ">> Nao existe um exame com esse codigo"
    else do
        removerExamePronto codigoDado
        print (">> Exame removido com sucesso.")

menuVerificarExame :: IO()
menuVerificarExame = do
    putStrLn "\nInforme o Codigo do seu Exame (o codigo se encontra no verso papel recebido):"
    codigoDado <- getLine
    
    examesProntos <- readFile "../db/examesProntos.txt"
    let listaQuebrada = T.splitOn (T.pack "\n") (T.pack examesProntos)
    let listaConvertida = [toExamePronto (T.unpack exame) | exame <- listaQuebrada]
    let listaBuscandoCodigo = [exame | exame <- listaConvertida, codigo exame == codigoDado]

    if (length listaBuscandoCodigo == 0) then print ">> Nenhum resultado encontrado com esse codigo"
    else do
        putStrLn "Informe a Senha do seu Exame (a senha se encontra abaixo do codigo, no mesmo papel):"
        senhaDada <- getLine
        if (codificaString (senhaDada) == senha (listaBuscandoCodigo !! 0)) then print (">> Perfeito! Nesse link voce pode conferir o resultado do seu exame: " ++ link (listaBuscandoCodigo !! 0))
        else print (">> Desculpe, sua senha nao coincide com a senha informada")

----------------------------Métodos Úteis---------------------------

-- ToString
toString :: ExamePronto -> String
toString (ExamePronto {codigo = c, senha = s, link = l}) = c ++ " | " ++ s ++ " | " ++ l

-- ToExamePronto
toExamePronto :: String -> ExamePronto
toExamePronto exameString = do
    let exameInList = T.splitOn (T.pack ", ") (T.pack exameString)
    ExamePronto {codigo = (T.unpack (exameInList !! 0)), senha = (T.unpack (exameInList !! 1)), link = (T.unpack (exameInList !! 2))}

-- Codifica String
codificaString :: String -> String
codificaString palavra = take ((length palavra) * 3) (cycle (reverse palavra))