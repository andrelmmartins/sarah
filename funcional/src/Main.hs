module Main where

import System.IO ()
import System.Directory ()

import Avaliacao
import Exames 
import Medico
import Convenios
import ExamePronto
import Utils
import Constantes

main:: IO()
main = do
  putStrLn "*********** Seja Bem-vindo ao SARAH ***********"
  putStrLn "Selecione o modo de operação. \n"
  putStrLn "1. Admin"
  putStrLn "2. Paciente"
  putStrLn "Para encerrar a sessão, digite qualquer outra tecla"
  putStr "-> "
  selecao <- getLine
  if selecao == "1" then menuPrincipalAdmin
  else if selecao == "2" then menuPrincipalCliente
  else print "Encerrando a sessao. Volte sempre ao SARAH =)"

menuPrincipalAdmin:: IO()
menuPrincipalAdmin = do
  putStrLn "Olá Admin! Qual módulo deseja acessar ?\n"
  putStrLn "1. Médicos"
  putStrLn "2. Convênios"
  putStrLn "3. Exames"
  putStrLn "4. Exames Prontos"
  putStrLn "5. Agendamentos"
  putStrLn "Para voltar ao menu principal, digite qualquer outra tecla."
  putStr "-> "
  selecao <- getLine
  case selecao of
    "1" -> mainMedicosAdmin
    "2" -> mainConveniosAdmin
    "3" -> mainExamesAdmin
    "4" -> mainExamesProntosAdmin
    -- "5" -> Agendamentos.main
    "6" -> mainAvaliacaoAdmin
    _ -> voltaAoMenuPrincipal


menuPrincipalCliente:: IO()
menuPrincipalCliente = do
  putStrLn "Olá! Em que a Sarah pode te ajudar hoje ?\n"
  putStrLn "1. Buscar Medicos"
  putStrLn "2. Buscar Convenios"
  putStrLn "3. Buscar Exames disponiveis"
  putStrLn "4. Buscar Resultados de Exames"
  putStrLn "5. Agendar Visita"
  putStrLn "6. Sugestões, elogios e reclamações"
  putStrLn "Para voltar ao menu principal, digite qualquer outra tecla."
  putStr "-> "
  selecao <- getLine
  case selecao of
    "1" -> mainMedicosCliente
    "2" -> mainConveniosCliente
    "3" -> mainExamesCliente
    "4" -> mainExamesProntosCliente
    -- "5" -> Agendamentos.main
    "6" -> mainAvaliacaoCliente
    _ -> voltaAoMenuPrincipal

voltaAoMenuPrincipal:: IO()
voltaAoMenuPrincipal = do
  putStrLn "Retornando ao menu inicial."
  main


------------------- Menus do módulo de Exames (ADMIN) -----------------------------------------

mainExamesAdmin:: IO()
mainExamesAdmin = do
    putStrLn "Ações disponíveis:\n"
    putStrLn "1. Cadastrar novo Exame"
    putStrLn "2. Buscar um Exame a partir do seu nome"
    putStrLn "3. Listar todos os exames cadastrados"
    putStrLn "4. Editar Exame a partir do seu nome"
    putStrLn "5. Remover um exame a partir do seu nome"
    putStrLn "Para voltar ao menu anterior, digite qualquer outro valor"
    selecao <- getLine
    case selecao of
        "1" -> mainAddExame
        "2" -> mainBuscaExamePeloNome
        "3" -> mainListarExames
        "4" -> mainEditarExamePeloNome
        "5" -> mainRemoverExamePeloNome
        _ -> menuPrincipalAdmin

mainListarExames::IO()
mainListarExames = do
    Exames.getAllExames
    voltaAoMenuAnterior mainExamesAdmin msgRetornaAoMenuInicialExames

mainBuscaExamePeloNome:: IO()
mainBuscaExamePeloNome = do
    Exames.menuBuscaExamePeloNome
    voltaAoMenuAnterior mainExamesAdmin msgRetornaAoMenuInicialExames

mainEditarExamePeloNome:: IO()
mainEditarExamePeloNome = do
    Exames.menuEditarExamePeloNome 
    voltaAoMenuAnterior mainExamesAdmin msgRetornaAoMenuInicialExames

mainRemoverExamePeloNome:: IO()
mainRemoverExamePeloNome = do
    Exames.menuRemoverExamePeloNome 
    voltaAoMenuAnterior mainExamesAdmin msgRetornaAoMenuInicialExames

mainAddExame:: IO()
mainAddExame = do
    Exames.menuAddExame 
    voltaAoMenuAnterior mainExamesAdmin msgRetornaAoMenuInicialExames

----------------- Menu do módulo de Exames (Cliente) -----------------------

mainExamesCliente:: IO()
mainExamesCliente = do
    putStrLn "Ações Disponíveis:\n"
    putStrLn "1. Listar todos os exames cadastrados"
    putStrLn "2. Buscar um Exame a partir do seu nome"
    putStrLn "Para voltar ao menu anterior, digite qualquer outro valor"
    selecao <- getLine
    case selecao of
        "1" -> mainListarExamesCliente
        "2" -> mainBuscaExamePeloNomeCliente
        _ -> menuPrincipalCliente

mainListarExamesCliente::IO()
mainListarExamesCliente = do
    Exames.getAllExames
    voltaAoMenuAnterior mainExamesCliente msgRetornaAoMenuInicialExames

mainBuscaExamePeloNomeCliente:: IO()
mainBuscaExamePeloNomeCliente = do
    Exames.menuBuscaExamePeloNome
    voltaAoMenuAnterior mainExamesCliente msgRetornaAoMenuInicialExames

----------------- Menus do módulo de convênios (ADMIN) ----------------------
mainConveniosAdmin :: IO()
mainConveniosAdmin = do
    putStrLn "Ações disponíveis:\n"
    putStrLn "1 - Cadastrar Convenio"
    putStrLn "2 - Remover Convenio"
    putStrLn "3 - Editar Convenio"
    putStrLn "4 - Listar Convenios"
    putStrLn "Para voltar ao menu anterior, digite qualquer outro valor\n"
    opcao <- getLine
    case opcao of 
        "1" -> mainAddConvenios
        "2" -> mainRemoverConvenios
        "3" -> mainEditarConvenios
        "4" -> mainListarConvenios
        _ -> menuPrincipalAdmin

mainAddConvenios :: IO()
mainAddConvenios = do
    Convenios.menuAdd 
    voltaAoMenuAnterior mainConveniosAdmin msgRetornaAoMenuInicialConvenios

mainRemoverConvenios :: IO()
mainRemoverConvenios = do
    Convenios.menuRemover
    voltaAoMenuAnterior mainConveniosAdmin msgRetornaAoMenuInicialConvenios

mainEditarConvenios :: IO()
mainEditarConvenios = do
    Convenios.menuEditarConvenios
    voltaAoMenuAnterior mainConveniosAdmin msgRetornaAoMenuInicialConvenios

mainListarConvenios:: IO()
mainListarConvenios = do
  listaConvenios
  voltaAoMenuAnterior mainConveniosAdmin msgRetornaAoMenuInicialConvenios
---------------------- Menu de Convênios (Cliente) -------------------------------

mainConveniosCliente:: IO()
mainConveniosCliente = do
  putStrLn "Ações disponíveis:\n"
  putStrLn "1 - Listar Convênios Aceitos"
  putStrLn "Para voltar ao menu anterior, digite qualquer outro valor\n"
  opcao <- getLine
  if opcao == "1" then mainListarConveniosParaCliente
  else menuPrincipalCliente

mainListarConveniosParaCliente:: IO()
mainListarConveniosParaCliente = do
  listaConvenios
  voltaAoMenuAnterior mainConveniosCliente msgRetornaAoMenuInicialConvenios

---------------------- Menus do modulo de Exames Prontos (Admin) ------------------
mainExamesProntosAdmin :: IO()
mainExamesProntosAdmin = do
    putStrLn "Ações disponíveis:\n"
    putStrLn "1 - Cadastrar Exame Pronto"
    putStrLn "2 - Editar Exame Pronto"
    putStrLn "3 - Remover Exame Pronto"
    putStrLn "4 - Listar Exames Prontos"
    putStrLn "Para voltar ao menu anterior, digite qualquer outro valor"
    putStr "-> "
    opcao <- getLine
    case opcao of 
        "1" -> mainCadastrarExamePronto
        "2" -> mainEditarExamePronto
        "3" -> mainRemoveExamePronto
        "4" -> mainListarExamesProntos
        _ -> menuPrincipalAdmin

mainCadastrarExamePronto::IO()
mainCadastrarExamePronto = do
  ExamePronto.menuCadastrarExame
  voltaAoMenuAnterior mainExamesProntosAdmin msgRetornaAoMenuInicialExamesProntos 

mainEditarExamePronto::IO()
mainEditarExamePronto = do
  ExamePronto.menuEditarExamePronto
  voltaAoMenuAnterior mainExamesProntosAdmin msgRetornaAoMenuInicialExamesProntos 

mainRemoveExamePronto::IO()
mainRemoveExamePronto = do
  ExamePronto.menuRemoverExame 
  voltaAoMenuAnterior mainExamesProntosAdmin msgRetornaAoMenuInicialExamesProntos 

mainListarExamesProntos:: IO()
mainListarExamesProntos = do
  ExamePronto.listarExamesProntos
  voltaAoMenuAnterior mainExamesProntosAdmin msgRetornaAoMenuInicialExamesProntos 

voltaAoMenuAnterior:: IO() -> String -> IO()
voltaAoMenuAnterior menu mensagem = do
  putStrLn "==============================================="
  putStrLn mensagem
  menu

---------------------- Menus do modulo de Exames Prontos (Cliente) ------------------

mainExamesProntosCliente :: IO()
mainExamesProntosCliente = do
    putStrLn "Ações disponíveis:\n"
    putStrLn "1 - Consultar exame a partir do codigo"
    putStrLn "Para voltar ao menu anterior, digite qualquer outro valor"
    putStr "-> "
    opcao <- getLine
    if opcao == "1" then mainConsultarExameProntoCliente
    else menuPrincipalCliente

mainConsultarExameProntoCliente:: IO()
mainConsultarExameProntoCliente = do
  ExamePronto.menuVerificarExame 
  voltaAoMenuAnterior mainExamesProntosCliente msgRetornaAoMenuInicialExamesProntos

--------------------------------- Menus do módulo de médicos (ADMIN) --------------------------
mainMedicosAdmin :: IO()
mainMedicosAdmin = do
    putStrLn "Ações disponíveis:\n"
    putStrLn "1 - Cadastrar Medico"
    putStrLn "2 - Listar Medicos"
    putStrLn "3 - Buscar Medico por CRM"
    putStrLn "4 - Editar Medico"
    putStrLn "5 - Remover Medico"
    putStrLn "Para voltar ao menu anterior, digite qualquer outro valor"
    putStr "-> "
    opcao <- getLine
    case opcao of 
        "1" -> mainCadastrarMedico
        "2" -> mainListarMedicos
        "3" -> mainEditarMedico
        "4" -> mainRemoverMedico
        _ -> menuPrincipalAdmin

mainCadastrarMedico:: IO()
mainCadastrarMedico = do 
  Medico.menuAdicionarMedico
  voltaAoMenuAnterior mainMedicosAdmin msgRetornaAoMenuInicialExamesProntos

mainListarMedicos:: IO()
mainListarMedicos = do
  Medico.listaDeMedicos
  voltaAoMenuAnterior mainMedicosAdmin msgRetornaAoMenuInicialExamesProntos 

mainEditarMedico:: IO()
mainEditarMedico = do
  Medico.menuEditarMedico
  voltaAoMenuAnterior mainMedicosAdmin msgRetornaAoMenuInicialExamesProntos
 
mainRemoverMedico:: IO()
mainRemoverMedico = do
  Medico.menuRemoverMedico
  voltaAoMenuAnterior mainMedicosAdmin msgRetornaAoMenuInicialExamesProntos

---------------------- Menus do módulo de Médicos (Cliente) ------------------------
mainMedicosCliente:: IO()
mainMedicosCliente = do
  putStrLn "Encontre seu medico aqui:\n"
  putStrLn "1 - Listar Medicos Disponíveis Aceitos"
  putStrLn "Para voltar ao menu anterior, digite qualquer outro valor\n"
  opcao <- getLine
  if opcao == "1" then mainListarMedicosParaCliente
  else menuPrincipalCliente

mainListarMedicosParaCliente:: IO()
mainListarMedicosParaCliente = do
  Medico.listaDeMedicos 
  voltaAoMenuAnterior mainMedicosCliente msgRetornaAoMenuInicialMedicos

---------------------- Menus do módulo de Avaliacao (Admin) ------------------------

mainAvaliacaoAdmin:: IO()
mainAvaliacaoAdmin = do
  Avaliacao.listaDeAvaliacoes
  menuPrincipalAdmin

---------------------- Menus do módulo de Avaliacao (Cliente) ------------------------

mainAvaliacaoCliente:: IO()
mainAvaliacaoCliente = do
  putStrLn "Nos ajude a melhorar! Deixe sua avaliacao: "
  avaliacao <- getLine
  Avaliacao.escreverAvaliacao avaliacao
  print "Avaliacao registrada com sucesso. Muito obrigado!"
  menuPrincipalCliente
