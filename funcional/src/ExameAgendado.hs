module ExameAgendado where

-- Imports
import Text.Read (Read)
import System.IO
import System.Directory
import qualified Data.Text as T
import qualified ExamePronto as EP

-- Construtor
data ExameAgendado = ExameAgendado {
    idExame :: String,
    crmMedico :: String,
    nomeMedico :: String,
    nomeExame :: String,
    dia :: String,
    hora :: String,
    status :: String
} deriving (Show, Read)

------------------------- Marcar Exame -------------------------

marcarExame :: String -> String -> String -> String -> String -> String -> String -> IO()
marcarExame idExame crmMedico nomeMedico nomeExame dia hora status = do
    appendFile "../db/examesAgendados.txt" (idExame ++ ", " ++ crmMedico ++ ", " ++ nomeMedico ++ ", " ++ nomeExame ++ ", " ++ dia ++ ", " ++ hora ++ ", " ++ status ++ "\n")
    return ()

------------------------- Cancelar Exame -------------------------

cancelarExame :: String -> IO()
cancelarExame idExameDado = do
    handle <- openFile "../db/examesAgendados.txt" ReadMode  
    tempdir <- getTemporaryDirectory  
    (tempName, tempHandle) <- openTempFile tempdir "temp"  
    contents <- hGetContents handle
    let listaComExames = lines contents
    let examesResultantes = [exame | exame <- listaComExames, (idExame (toExameAgendado exame)) /= idExameDado]
    let examesFormatados = map (T.unpack . T.toTitle . T.pack) examesResultantes
    hPutStr tempHandle $ unlines examesFormatados 
    hClose handle  
    hClose tempHandle  
    removeFile "../db/examesAgendados.txt" 
    renameFile tempName "../db/examesAgendados.txt"

------------------------- Listar Exames -------------------------

-- Listar todos os exames agendados
listarExames :: IO()
listarExames = do
    handle <- openFile "../db/examesAgendados.txt" ReadMode  
    conteudo <- hGetContents handle
    let listaQuebrada = T.splitOn (T.pack "\n") (T.pack conteudo)
    let listaConvertida = [ toExameAgendado (T.unpack exame) | exame <- listaQuebrada, exame /= (T.pack "")]
    putStr (listaToString listaConvertida)
    hClose handle

-- Listar Exames Em Aberto
listarExamesEmAberto :: IO()
listarExamesEmAberto = do
    handle <- openFile "../db/examesAgendados.txt" ReadMode  
    conteudo <- hGetContents handle
    let listaQuebrada = T.splitOn (T.pack "\n") (T.pack conteudo)
    let listaConvertida = [ toExameAgendado (T.unpack exame) | exame <- listaQuebrada, exame /= (T.pack "") && ((T.splitOn (T.pack ", ") (exame)) !! 6) == T.pack "Em Aberto"]
    putStr (listaToString listaConvertida)
    hClose handle

-- Listar Exames Concluídos
listarExamesConcluidos :: IO()
listarExamesConcluidos = do
    handle <- openFile "../db/examesAgendados.txt" ReadMode  
    conteudo <- hGetContents handle
    let listaQuebrada = T.splitOn (T.pack "\n") (T.pack conteudo)
    let listaConvertida = [ toExameAgendado (T.unpack exame) | exame <- listaQuebrada, exame /= (T.pack "") && ((T.splitOn (T.pack ", ") (exame)) !! 6) == T.pack "Concluido"]
    putStr (listaToString listaConvertida)
    hClose handle

-- Listar Exames Concluídos
listarExamesDia :: String -> IO()
listarExamesDia diaDado = do
    handle <- openFile "../db/examesAgendados.txt" ReadMode  
    conteudo <- hGetContents handle
    let listaQuebrada = T.splitOn (T.pack "\n") (T.pack conteudo)
    let listaConvertida = [ toExameAgendado (T.unpack exame) | exame <- listaQuebrada, exame /= (T.pack "") && ((T.splitOn (T.pack ", ") (exame)) !! 4) == T.pack diaDado]
    putStr (listaToString listaConvertida)
    hClose handle

listaToString :: [ExameAgendado] -> String
listaToString [] = []
listaToString (e:es) = if not (null es) then do "[ " ++ toString e ++ " ]\n" ++ listaToString es
    else do "[ " ++ toString e ++ " ]\n"

------------------------- Editar Exame -------------------------

editarExameAgendado :: String -> String -> String -> String -> String -> String -> String -> IO()
editarExameAgendado idExame crmMedico nomeMedico nomeExame dia hora status = do
    cancelarExame idExame
    marcarExame idExame crmMedico nomeMedico nomeExame dia hora status
    return ()

------------------------- Buscar Exame -------------------------

buscarExame :: String -> IO(String)
buscarExame idExame = do
    exames <- readFile "../db/examesAgendados.txt"
    let listaExames = T.splitOn (T.pack "\n") (T.pack exames)
    let examesEncontrados = [ T.unpack exame | exame <- listaExames, exame /= (T.pack "") && ((T.splitOn (T.pack ", ") (exame)) !! 0) == T.pack idExame ]
    if ((length examesEncontrados) == 0) then return (" ")
    else return ((examesEncontrados !! 0))

buscarExameComCRMeDia :: String -> String -> IO([String])
buscarExameComCRMeDia crm dia = do
    exames <- readFile "../db/examesAgendados.txt"
    let listaExames = T.splitOn (T.pack "\n") (T.pack exames)
    let examesEncontrados = [ T.unpack exame | exame <- listaExames, exame /= (T.pack "") && ((T.splitOn (T.pack ", ") (exame)) !! 1) == T.pack crm && ((T.splitOn (T.pack ", ") (exame)) !! 4) == T.pack dia ]
    return (examesEncontrados)

------------------------- Concluír Exame -------------------------

concluirExame :: String -> String -> String -> IO()
concluirExame idExameDado senha link = do
    exameString <- buscarExame idExameDado
    let exame = toExameAgendado exameString
    editarExameAgendado (idExame exame) (crmMedico exame) (nomeMedico exame) (nomeExame exame) (dia exame) (hora exame) "Concluido"
    EP.cadastrarExamePronto idExameDado senha link
    return()

------------------------- Menu -------------------------

-- Menu Marcar Exame
menuMarcarExame :: IO()
menuMarcarExame = do
    putStrLn "\nExames:"
    exames <- getListaExamesNome
    if(length exames == 0) then putStrLn ("Nao temos exames disponiveis")
    else do
        putStrLn (printaListaString exames 0)
        putStr "> Dentre os exames listados, digite o número de qual você pretende marcar? "
        exameStr <- getLine
        let exameInt = (read exameStr) :: Int
        if(exameInt < 0 || exameInt > ((length exames) - 1)) then putStrLn ("Esse exame nao esta na lista")
        else do
            let exame = (exames !! exameInt)
            putStr "\nQual data você pretende fazer o exame? "
            dia <- getLine
            if (not (verificaSeDataOk dia)) then putStrLn ("Essa data nao e valida")
            else do
                medicos <- getListaMedicos
                if (length medicos == 0) then putStrLn ("Nao temos medicos disponiveis")
                else do
                    let nomesMedicos = [T.unpack ((T.splitOn (T.pack ",") (T.pack medico))!! 1) | medico <- medicos]
                    putStrLn ("\n" ++ printaListaString nomesMedicos 0)
                    putStr "> Dentre os medicos listados, digite o número de qual você deseja ser atendido? "
                    medicoStr <- getLine
                    let medicoInt = (read medicoStr) :: Int
                    if(medicoInt < 0 || medicoInt > ((length nomesMedicos) - 1)) then putStrLn ("Esse medico nao esta na lista")
                    else do
                        let nomeMedico = (nomesMedicos !! medicoInt)
                        let crm = T.unpack ((T.splitOn (T.pack ",") (T.pack (medicos !! medicoInt)))!! 0)
                        horarios <- montaHorariosMedico crm dia
                        if (length horarios == 0) then putStrLn ("Esse medico esta com a agenda cheia nesse dia")
                        else do
                            let hora = (horarios !! 0)
                            ultimoId <- pegaUltimoID
                            let idExame =  show (ultimoId + 1)
                            marcarExame idExame crm nomeMedico exame dia hora "Em aberto"
                            putStrLn ("\nExame marcado com sucesso! > Codigo: " ++ idExame ++ " | " ++ exame ++ " | Medico: " ++ nomeMedico ++ " | " ++ dia ++ " - " ++ hora)

-- Menu Cancelar Exame
menuCancelarExame :: IO()
menuCancelarExame = do
    putStr "\nQual o ID do Exame que você pretende cancelar? "
    idExame <- getLine
    exameEncontrado <- buscarExame idExame
    if (exameEncontrado == " ") then putStrLn ("Esse exame nao existe no sistema")
    else do
        let exame = toExameAgendado exameEncontrado
        cancelarExame idExame
        putStrLn ("Exame de " ++ nomeExame exame ++ " com o Medico " ++ nomeMedico exame ++ " foi cancelado!")


-- Menu Concluir Exame
menuConcluirExame :: IO()
menuConcluirExame = do
    putStr "\nQual o ID do Exame que você pretende dar como concluído? "
    idExame <- getLine
    exameEncontrado <- buscarExame idExame
    if (exameEncontrado == " ") then putStrLn ("Esse exame nao existe no sistema")
    else do
        putStr "Para que o cliente consiga acessar o resultado, digite uma senha: "
        senha <- getLine
        putStr "Agora informe o link do resultado do exame: "
        link <- getLine
        let exame = toExameAgendado exameEncontrado
        concluirExame idExame senha link
        putStrLn ("Exame de " ++ nomeExame exame ++ " com o Medico " ++ nomeMedico exame ++ " foi concluido!")

-- Menu Editar Agenda
menuEditarAgenda :: IO()
menuEditarAgenda = do
    putStr "Informe o ID do Exame que vai ser editado: "
    idExame <- getLine
    exameEncontrado <- buscarExame idExame
    if (exameEncontrado /= " ") then do
        putStrLn "\nExames:"
        exames <- getListaExamesNome
        if(length exames == 0) then putStrLn ("Nao temos exames disponiveis")
        else do
            putStrLn (printaListaString exames 0)
            putStr "> Dentre os exames listados, digite o numero para qual você pretende editar? "
            exameStr <- getLine
            let exameInt = (read exameStr) :: Int
            if(exameInt < 0 || exameInt > ((length exames) - 1)) then putStrLn ("Esse exame nao esta na lista")
            else do
                let exame = (exames !! exameInt)
                putStr "\nQual a nova data que pretende fazer o exame? "
                dia <- getLine
                if (not (verificaSeDataOk dia)) then putStrLn ("Essa data nao e valida")
                else do
                    medicos <- getListaMedicos
                    if (length medicos == 0) then putStrLn ("Nao temos medicos disponiveis")
                    else do
                        let nomesMedicos = [T.unpack ((T.splitOn (T.pack ",") (T.pack medico))!! 1) | medico <- medicos]
                        putStrLn ("\n" ++ printaListaString nomesMedicos 0)
                        putStr "> Dentre os medicos listados, digite o numero do novo medico que voce deseja ser atendido? "
                        medicoStr <- getLine
                        let medicoInt = (read medicoStr) :: Int
                        if(medicoInt < 0 || medicoInt > ((length nomesMedicos) - 1)) then putStrLn ("Esse medico nao esta na lista")
                        else do
                            let nomeMedico = (nomesMedicos !! medicoInt)
                            let crm = T.unpack ((T.splitOn (T.pack ",") (T.pack (medicos !! medicoInt)))!! 0)
                            horarios <- montaHorariosMedico crm dia
                            if (length horarios == 0) then putStrLn ("Esse medico esta com a agenda cheia nesse dia")
                            else do
                                putStrLn "\nHorarios:"
                                putStrLn (printaListaString horarios 0)
                                putStr "> Dentre os horarios listados, digite o numero para qual você pretende agendar? "
                                horaStr <- getLine
                                let horaInt = (read horaStr) :: Int
                                if(horaInt < 0 || horaInt > ((length horarios) - 1)) then putStrLn ("Esse horario nao esta na lista")
                                else do
                                    let hora = (horarios !! horaInt)
                                    putStr "\nQual o novo status desse exame? Concluido ou Em Aberto : "
                                    status <- getLine
                                    if (not (status `elem` ["Concluido", "Em Aberto"]) then putStrLn ("Esse status nao e aceito")
                                    else do
                                        editarExameAgendado idExame crm nomeMedico exame dia hora status
                                        putStrLn ("\nExame editado com sucesso! > Codigo: " ++ idExame ++ " | " ++ exame ++ " | Medico: " ++ nomeMedico ++ " | " ++ dia ++ " - " ++ hora)

    else putStrLn "Esse Exame Agendado nao existe"

------------------------- Metodos Úteis -------------------------

toString :: ExameAgendado -> String
toString (ExameAgendado {idExame = id, crmMedico = crm, nomeMedico = medico, nomeExame = exame, dia = dia, hora = hora, status = status}) = id ++ " | " ++ exame ++ " | " ++ medico ++ " / " ++ crm ++ " | " ++ dia ++ " - " ++ hora ++ " | " ++ status

toExameAgendado :: String -> ExameAgendado
toExameAgendado exameString = do
    let exameInList = T.splitOn (T.pack ", ") (T.pack exameString)
    ExameAgendado {idExame = (T.unpack (exameInList !! 0)), crmMedico = (T.unpack (exameInList !! 1)), nomeMedico = (T.unpack (exameInList !! 2)), nomeExame = (T.unpack (exameInList !! 3)), dia = (T.unpack (exameInList !! 4)), hora = (T.unpack (exameInList !! 5)), status = (T.unpack (exameInList !! 6)) }

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

pegaUltimoID :: IO(Int)
pegaUltimoID = do
    exames <- readFile "../db/examesAgendados.txt"
    let listaExames = T.splitOn (T.pack "\n") (T.pack exames)
    let examesEncontrados = [exame | exame <- listaExames, exame /= (T.pack "")]
    if (length examesEncontrados == 0) then return (0)
    else do
        let ultimo = examesEncontrados !! ((length examesEncontrados) - 1)
        return (read (T.unpack ((T.splitOn (T.pack ", ") (ultimo)) !! 0)) :: Int)

------------------------- Metodos Sobre Exames -------------------------

getListaExamesNome :: IO([String])
getListaExamesNome = do
    exames <- readFile "../db/exames.txt"
    let listaExames = T.splitOn (T.pack "\n") (T.pack exames)
    let examesEncontrados = [ T.unpack ((T.splitOn (T.pack ", ") (exame)) !! 0) | exame <- listaExames, exame /= (T.pack "") ]
    return (examesEncontrados)

printaListaString :: [String] -> Int -> String
printaListaString [] 0 = []
printaListaString (e:es) indice = if not (null es) then do show indice ++ " - " ++ e ++ "\n" ++ printaListaString es (indice + 1)
    else do show indice ++ " - " ++ e ++ "\n"

------------------------- Metodos Sobre Medicos -------------------------

montaHorariosMedico :: String -> String -> IO([String])
montaHorariosMedico crm dia = do
    examesNoDia <- buscarExameComCRMeDia crm dia
    let horariosOcupados = [T.unpack ((T.splitOn (T.pack ", ") (T.pack exame)) !! 5) | exame <- examesNoDia]
    let horariosLivres = [hora | hora <- horarios, not (hora `elem` horariosOcupados)]
    return (horariosLivres)
    where
        horarios = ["08h00", "09h00", "10h00", "11h00", "12h00", "13h00","14h00","15h00", "16h00", "17h00"]

getListaMedicos :: IO([String])
getListaMedicos = do
    medicos <- readFile "../db/medicos.txt"
    let listaMedicos = T.splitOn (T.pack "\n") (T.pack medicos)
    let medicosEncontrados = [ T.unpack medico | medico <- listaMedicos, medico /= (T.pack "") ]
    return (medicosEncontrados)

