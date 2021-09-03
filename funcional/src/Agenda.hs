module Agenda where

-- Imports
import System.IO
import System.Directory
import qualified Data.Text as T
import Data.Typeable

-- Construtor
data Agenda = Agenda {
    dia :: String,
    visitas_8_as_10 :: Int,
    visitas_10_as_12 :: Int,
    visitas_12_as_14 :: Int,
    visitas_14_as_16 :: Int,
    visitas_16_as_18 :: Int
} deriving (Show, Read)

---------------------------Criar uma Agenda-------------------------------------

criarAgenda :: String -> IO()
criarAgenda dia = do
    appendFile "../db/agendas.txt" (dia ++ ", " ++ (show 0) ++ ", " ++ (show 0) ++ ", " ++ (show 0) ++ ", " ++ (show 0) ++ ", " ++ (show 0) ++ "\n")
    return ()

cadastrarAgenda :: String -> String -> String -> String -> String -> String -> IO()
cadastrarAgenda dia visitas1 visitas2 visitas3 visitas4 visitas5 = do
    appendFile "../db/agendas.txt" (dia ++ ", " ++ visitas1 ++ ", " ++ visitas2 ++ ", " ++ visitas3 ++ ", " ++ visitas4 ++ ", " ++ visitas5 ++ "\n")
    return ()

---------------------------Buscar uma Agenda------------------------------------

buscaUmaAgenda:: String -> IO()
buscaUmaAgenda diaDado = do
    agendas <- readFile "../db/agendas.txt"
    let listaAgendas = T.splitOn (T.pack "\n") (T.pack agendas)
    let agendasConvertidas = [ toAgenda (T.unpack agenda) | agenda <- listaAgendas]
    let listaEncontrada = [ agenda | agenda <- agendasConvertidas, dia agenda == diaDado]
    if (length listaEncontrada == 0) then print ("Agenda nao encontrada")
    else print (listaEncontrada !! 0)

---------------------------Listar Agendas---------------------------------------

listarAgendas :: IO()
listarAgendas = do
    handle <- openFile "../db/agendas.txt" ReadMode  
    conteudo <- hGetContents handle
    let listaQuebrada = T.splitOn (T.pack "\n") (T.pack conteudo)
    let listaConvertida = [ toAgenda (T.unpack agenda) | agenda <- listaQuebrada, agenda /= (T.pack "")]
    putStr (listaToString listaConvertida)
    hClose handle

listaToString :: [Agenda] -> String
listaToString [] = []
listaToString (e:es) = if not (null es) then do toString e ++ "\n\n" ++ listaToString es
    else do toString e ++ "\n"

---------------------------Remover uma Agenda-----------------------------------

removerAgenda :: String -> IO()
removerAgenda diaDado = do
    handle <- openFile "../db/agendas.txt" ReadMode  
    tempdir <- getTemporaryDirectory  
    (tempName, tempHandle) <- openTempFile tempdir "temp"  
    contents <- hGetContents handle
    let listaComAgendas = lines contents
    let agendasResultantes = [agenda | agenda <- listaComAgendas, (dia (toAgenda agenda)) /= diaDado]
    let agendasFormatadas = map (T.unpack . T.toTitle . T.pack) agendasResultantes
    hPutStr tempHandle $ unlines agendasFormatadas 
    hClose handle  
    hClose tempHandle  
    removeFile "../db/agendas.txt" 
    renameFile tempName "../db/agendas.txt"

---------------------------Editar uma Agenda------------------------------------

editarAgenda :: String -> String -> String -> String -> String -> String -> String -> IO()
editarAgenda dia novoDia visitas1 visitas2 visitas3 visitas4 visitas5 = do
    removerAgenda dia
    cadastrarAgenda novoDia visitas1 visitas2 visitas3 visitas4 visitas5
    return ()

---------------------------Agendar uma visita-----------------------------------

agendarVisita :: String -> IO()
agendarVisita diaEscolhido = do
    agendas <- readFile "../db/agendas.txt"
    let listaAgendas = T.splitOn (T.pack "\n") (T.pack agendas)
    let agendasConvertidas = [ toAgenda (T.unpack agenda) | agenda <- listaAgendas]
    let listaEncontrada = [ agenda | agenda <- agendasConvertidas, dia agenda == diaEscolhido]
    if ((length listaEncontrada) == 0) then do
        cadastrarAgenda diaEscolhido "1" "0" "0" "0" "0"
        print ("\nVoce foi agendado para " ++ diaEscolhido ++ " entre 8h as 10h")
    else do
        let agenda = (listaEncontrada !! 0)
        if ((visitas_8_as_10 agenda) < 30) then do
            editarAgenda diaEscolhido diaEscolhido (show ((visitas_8_as_10 agenda) + 1)) (show (visitas_10_as_12 agenda)) (show (visitas_12_as_14 agenda)) (show (visitas_14_as_16 agenda)) (show (visitas_16_as_18 agenda))
            print ("\nVoce foi agendado para " ++ diaEscolhido ++ " entre 8h as 10h")
        else if((visitas_10_as_12 agenda) < 30) then do
            editarAgenda diaEscolhido diaEscolhido (show (visitas_8_as_10 agenda)) (show ((visitas_10_as_12 agenda) + 1)) (show (visitas_12_as_14 agenda)) (show (visitas_14_as_16 agenda)) (show (visitas_16_as_18 agenda))
            print ("\nVoce foi agendado para " ++ diaEscolhido ++ " entre 10h as 12h")
        else if((visitas_12_as_14 agenda) < 30) then do
            editarAgenda diaEscolhido diaEscolhido (show (visitas_8_as_10 agenda)) (show (visitas_10_as_12 agenda)) (show ((visitas_12_as_14 agenda) + 1)) (show (visitas_14_as_16 agenda)) (show (visitas_16_as_18 agenda))
            print ("\nVoce foi agendado para " ++ diaEscolhido ++ " entre 12h as 14h")
        else if((visitas_14_as_16 agenda) < 30) then do
            editarAgenda diaEscolhido diaEscolhido (show (visitas_8_as_10 agenda)) (show (visitas_10_as_12 agenda)) (show (visitas_12_as_14 agenda)) (show ((visitas_14_as_16 agenda) + 1)) (show (visitas_16_as_18 agenda))
            print ("\nVoce foi agendado para " ++ diaEscolhido ++ " entre 14h as 16h")
        else if((visitas_16_as_18 agenda) < 30) then do
            editarAgenda diaEscolhido diaEscolhido (show (visitas_8_as_10 agenda)) (show (visitas_10_as_12 agenda)) (show (visitas_12_as_14 agenda)) (show (visitas_14_as_16 agenda)) (show ((visitas_16_as_18 agenda) + 1))
            print ("\nVoce foi agendado para " ++ diaEscolhido ++ " entre 16h as 18h")
        else print ("Nao temos mais vagas para este dia!")

---------------------------Cancelar uma Visita----------------------------------

cancelarUmaVisita :: String -> String -> IO()
cancelarUmaVisita diaAgendado horario = do
    agendas <- readFile "../db/agendas.txt"
    let listaAgendas = T.splitOn (T.pack "\n") (T.pack agendas)
    let agendasConvertidas = [ toAgenda (T.unpack agenda) | agenda <- listaAgendas]
    let listaEncontrada = [ agenda | agenda <- agendasConvertidas, dia agenda == diaAgendado]
    if ((length listaEncontrada) == 0) then do
        print "\nNao tem nenhum agendamento para este dia."
    else do
        let agenda = (listaEncontrada !! 0)
        if ((visitas_8_as_10 agenda) > 0 && horario == "8h as 10h") then do
            editarAgenda diaAgendado diaAgendado (show ((visitas_8_as_10 agenda) - 1)) (show (visitas_10_as_12 agenda)) (show (visitas_12_as_14 agenda)) (show (visitas_14_as_16 agenda)) (show (visitas_16_as_18 agenda))
            print ("\nAgendamento para " ++ diaAgendado ++ " entre 8h as 10h foi cancelado")
        else if((visitas_10_as_12 agenda) > 0 && horario == "10h as 12h") then do
            editarAgenda diaAgendado diaAgendado (show (visitas_8_as_10 agenda)) (show ((visitas_10_as_12 agenda) - 1)) (show (visitas_12_as_14 agenda)) (show (visitas_14_as_16 agenda)) (show (visitas_16_as_18 agenda))
            print ("\nAgendamento para " ++ diaAgendado ++ " entre 10h as 12h foi cancelado")
        else if((visitas_12_as_14 agenda) > 0 && horario == "12h as 14h") then do
            editarAgenda diaAgendado diaAgendado (show (visitas_8_as_10 agenda)) (show (visitas_10_as_12 agenda)) (show ((visitas_12_as_14 agenda) - 1)) (show (visitas_14_as_16 agenda)) (show (visitas_16_as_18 agenda))
            print ("\nAgendamento para " ++ diaAgendado ++ " entre 12h as 14h foi cancelado")
        else if((visitas_14_as_16 agenda) > 0 && horario == "14h as 16h") then do
            editarAgenda diaAgendado diaAgendado (show (visitas_8_as_10 agenda)) (show (visitas_10_as_12 agenda)) (show (visitas_12_as_14 agenda)) (show ((visitas_14_as_16 agenda) - 1)) (show (visitas_16_as_18 agenda))
            print ("\nAgendamento para " ++ diaAgendado ++ " entre 14h as 16h foi cancelado")
        else if((visitas_16_as_18 agenda) > 0 && horario == "16h as 18h") then do
            editarAgenda diaAgendado diaAgendado (show (visitas_8_as_10 agenda)) (show (visitas_10_as_12 agenda)) (show (visitas_12_as_14 agenda)) (show (visitas_14_as_16 agenda)) (show ((visitas_16_as_18 agenda) - 1))
            print ("\nAgendamento para " ++ diaAgendado ++ " entre 16h as 18h foi cancelado")
        else print ("\nNao tem nenhum agendamento para este horario.")

---------------------------Menus------------------------------------------------

menuCadastrarAgenda :: IO()
menuCadastrarAgenda = do
    putStr "\nQual data você gostaria de cadastrar uma agenda? [dd/MM/yyyy]: "
    dia <- getLine
    if (verificaSeDataOk dia) then do
        existe <- verificaSeAgendaExiste dia
        if (existe) then print ("Essa agenda ja existe no banco.")
        else do
            criarAgenda dia
            print "Agenda criada!"
    else print "Esse nao e um formato de data"


menuRemoverAgenda :: IO()
menuRemoverAgenda = do
    putStr "\nQual a data da agenda que você pretende remover? [dd/MM/yyyy]: "
    dia <- getLine
    if (verificaSeDataOk dia) then do
        existe <- verificaSeAgendaExiste dia
        if (existe) then do
            removerAgenda dia
            print "Agenda removida!"
        else print ("Essa agenda nao existe no banco.")
    else print "Esse nao e um formato de data"

menuEditarAgenda :: IO()
menuEditarAgenda = do
    putStr "Informe a data da Agenda que vai ser editada: [dd/MM/yyyy]: "
    dia <- getLine
    if (verificaSeDataOk dia) then do
        existe <- verificaSeAgendaExiste dia
        if (existe) then do
            putStr "Informe a nova data da Agenda que vai ser editada: [dd/MM/yyyy]: "
            novoDia <- getLine
            if (verificaSeDataOk dia) then do
                novoExiste <- verificaSeAgendaExiste novoDia
                if (novoExiste && novoDia /= dia) then print "Essa data ja existe no banco"
                else do
                    putStr "Informe a quantidade de visitas das 08h as 10h: [0 a 30]: "
                    visitas1 <- getLine
                    putStr "Informe a quantidade de visitas das 10h as 12h: [0 a 30]: "
                    visitas2 <- getLine
                    putStr "Informe a quantidade de visitas das 12h as 14h: [0 a 30]: "
                    visitas3 <- getLine
                    putStr "Informe a quantidade de visitas das 14h as 16h: [0 a 30]: "
                    visitas4 <- getLine
                    putStr "Informe a quantidade de visitas das 16h as 18h: [0 a 30]: "
                    visitas5 <- getLine
                    editarAgenda dia novoDia visitas1 visitas2 visitas3 visitas4 visitas5
                    print "Agenda editada!"
            else print "Essa data nao e valida" 
        else print "Essa agenda nao existe no bando para ser editada"
    else print "Essa data nao e valida"

menuAgendarVisita :: IO()
menuAgendarVisita = do
    putStr "Que data você pretende visitar nossa clínica? [dd/MM/yyyy]: "
    dia <- getLine
    if (verificaSeDataOk dia) then do agendarVisita dia
    else print "Essa data nao e valida"

---------------------------Métodos Úteis----------------------------------------

toString :: Agenda -> String
toString (Agenda {dia = d, visitas_8_as_10 = visitas1, visitas_10_as_12 = visitas2, visitas_12_as_14 = visitas3, visitas_14_as_16 = visitas4, visitas_16_as_18 = visitas5}) = d ++ "\n | De 8h às 10h: " ++ (show visitas1) ++ " visitas\n | De 10h às 12: " ++ (show visitas2) ++ " visitas\n | De 12h às 14: " ++ (show visitas3) ++ " visitas\n | De 14h às 16: " ++ (show visitas4) ++ " visitas\n | De 16h às 18: " ++ (show visitas5) ++ " visitas"

toAgenda :: String -> Agenda
toAgenda agendaString = do
    let agendaInList = T.splitOn (T.pack ", ") (T.pack agendaString)
    Agenda {dia = (T.unpack (agendaInList !! 0)), visitas_8_as_10 = (read (T.unpack (agendaInList !! 1))::Int), visitas_10_as_12 = (read (T.unpack (agendaInList !! 2))::Int), visitas_12_as_14 = (read (T.unpack (agendaInList !! 3))::Int), visitas_14_as_16 = (read (T.unpack (agendaInList !! 4))::Int), visitas_16_as_18 = (read (T.unpack (agendaInList !! 5))::Int) }

verificaSeDataOk :: String -> Bool
verificaSeDataOk dataDada = 
    if (length dataList == 3) then do
        if(length (T.unpack (dataList !! 0)) == 2) then do
            if(length (T.unpack (dataList !! 1)) == 2) then do
                if(length (T.unpack (dataList !! 2)) == 4) then do True
                else False
            else False
        else False
    else False
    where
        dataList = T.splitOn (T.pack "/") (T.pack dataDada)

verificaSeAgendaExiste :: String -> IO(Bool)
verificaSeAgendaExiste diaDado = do
    agendas <- readFile "../db/agendas.txt"
    let listaAgendas = T.splitOn (T.pack "\n") (T.pack agendas)
    let agendasConvertidas = [ toAgenda (T.unpack agenda) | agenda <- listaAgendas]
    let listaEncontrada = [ agenda | agenda <- agendasConvertidas, dia agenda == diaDado]
    if ((length listaEncontrada) == 0) then do
        return (False)
    else do
        return (True)