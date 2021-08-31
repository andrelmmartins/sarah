module Main where

import System.IO ()
import System.Directory ()

import Exames 
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
  else if selecao == "2" then menuInicialCliente
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
    -- "1" -> mainMedicos
    "2" -> mainConvenios
    "3" -> mainExames
    "4" -> mainExamesProntosAdmin
    -- "5" -> Agendamentos.main
    _ -> voltaAoMenuPrincipal

voltaAoMenuPrincipal:: IO()
voltaAoMenuPrincipal = do
  putStrLn "Retornando ao menu inicial."
  main

menuInicialCliente:: IO()
menuInicialCliente = do
  print "fim"

------------------- Menus do módulo de Exames -----------------------------------------

mainExames:: IO()
mainExames = do
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
    voltaAoMenuAnterior mainExames msgRetornaAoMenuInicialExames

mainBuscaExamePeloNome:: IO()
mainBuscaExamePeloNome = do
    Exames.menuBuscaExamePeloNome
    voltaAoMenuAnterior mainExames msgRetornaAoMenuInicialExames

mainEditarExamePeloNome:: IO()
mainEditarExamePeloNome = do
    Exames.menuEditarExamePeloNome 
    voltaAoMenuAnterior mainExames msgRetornaAoMenuInicialExames

mainRemoverExamePeloNome:: IO()
mainRemoverExamePeloNome = do
    Exames.menuRemoverExamePeloNome 
    voltaAoMenuAnterior mainExames msgRetornaAoMenuInicialExames

mainAddExame:: IO()
mainAddExame = do
    Exames.menuAddExame 
    voltaAoMenuAnterior mainExames msgRetornaAoMenuInicialExames

----------------- Menus do módulo de convênios ----------------------
mainConvenios :: IO()
mainConvenios = do
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
    voltaAoMenuAnterior mainConvenios msgRetornaAoMenuInicialConvenios

mainRemoverConvenios :: IO()
mainRemoverConvenios = do
    Convenios.menuRemover
    voltaAoMenuAnterior mainConvenios msgRetornaAoMenuInicialConvenios

mainEditarConvenios :: IO()
mainEditarConvenios = do
    Convenios.menuEditarConvenios
    voltaAoMenuAnterior mainConvenios msgRetornaAoMenuInicialConvenios

mainListarConvenios:: IO()
mainListarConvenios = do
  listaConvenios
  voltaAoMenuAnterior mainConvenios msgRetornaAoMenuInicialConvenios

---------------------- Menus do modulo de Exames Prontos (Admin) ------------------
mainExamesProntosAdmin :: IO()
mainExamesProntosAdmin = do
    putStrLn "Ações disponíveis:\n"
    putStrLn "1 - Cadastrar Exame Pronto"
    putStrLn "2 - Remover Convenio"
    putStrLn "3 - Editar Convenio"
    putStrLn "4 - Listar Convenios"
    putStrLn "Para voltar ao menu anterior, digite qualquer outro valor"
    putStr "-> "
    opcao <- getLine
    case opcao of 
        "1" -> mainCadastrarExamePronto
        "2" -> mainEditarExamePronto
        "3" -> mainRemoveExamePronto
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

voltaAoMenuAnterior:: IO() -> String -> IO()
voltaAoMenuAnterior menu mensagem = do
  putStrLn "==============================================="
  putStrLn mensagem
  menu

--------------------------------- Menus do módulo de médicos --------------------------
