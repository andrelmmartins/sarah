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
import Agenda
import ExameAgendado
import Home

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
  putStrLn "6. Avaliações"
  putStrLn "7. Exames Agendados"
  putStrLn "Para voltar ao menu principal, digite qualquer outra tecla."
  putStr "-> "
  selecao <- getLine
  case selecao of
    "1" -> mainMedicosAdmin
    "2" -> mainConveniosAdmin
    "3" -> mainExamesAdmin
    "4" -> mainExamesProntosAdmin
    "5" -> mainAgendaAdmin
    "6" -> mainAvaliacaoAdmin
    "7" -> mainExamesAgendadosAdmin
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
  putStrLn "7. Agendar Exame"
  putStrLn "8. Conheca nossa clinica"
  putStrLn "Para voltar ao menu principal, digite qualquer outra tecla."
  putStr "-> "
  selecao <- getLine
  case selecao of
    "1" -> mainMedicosCliente
    "2" -> mainConveniosCliente
    "3" -> mainExamesCliente
    "4" -> mainExamesProntosCliente
    "5" -> mainAgendaCliente
    "6" -> mainAvaliacaoCliente
    "7" -> mainAgendarExameCliente
    "8" -> mainWelcomeMsg
    _ -> voltaAoMenuPrincipal

voltaAoMenuPrincipal:: IO()
voltaAoMenuPrincipal = do
  putStrLn "Retornando ao menu inicial."
  main

voltaAoMenuAnterior:: IO() -> String -> IO()
voltaAoMenuAnterior menu mensagem = do
  putStrLn "==============================================="
  putStrLn mensagem
  menu


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
    putStrLn "==============================================="
    Exames.getAllExames
    voltaAoMenuAnterior mainExamesAdmin msgRetornaAoMenuInicialExames

mainBuscaExamePeloNome:: IO()
mainBuscaExamePeloNome = do
    putStrLn "==============================================="
    Exames.menuBuscaExamePeloNome
    voltaAoMenuAnterior mainExamesAdmin msgRetornaAoMenuInicialExames

mainEditarExamePeloNome:: IO()
mainEditarExamePeloNome = do
    putStrLn "==============================================="
    Exames.menuEditarExamePeloNome 
    voltaAoMenuAnterior mainExamesAdmin msgRetornaAoMenuInicialExames

mainRemoverExamePeloNome:: IO()
mainRemoverExamePeloNome = do
    putStrLn "==============================================="
    Exames.menuRemoverExamePeloNome 
    voltaAoMenuAnterior mainExamesAdmin msgRetornaAoMenuInicialExames

mainAddExame:: IO()
mainAddExame = do
    putStrLn "==============================================="
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
    putStrLn "==============================================="
    Exames.getAllExames
    voltaAoMenuAnterior mainExamesCliente msgRetornaAoMenuInicialExames

mainBuscaExamePeloNomeCliente:: IO()
mainBuscaExamePeloNomeCliente = do
    putStrLn "==============================================="
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
    putStrLn "==============================================="
    Convenios.menuAdd 
    voltaAoMenuAnterior mainConveniosAdmin msgRetornaAoMenuInicialConvenios

mainRemoverConvenios :: IO()
mainRemoverConvenios = do
    putStrLn "==============================================="
    Convenios.menuRemover
    voltaAoMenuAnterior mainConveniosAdmin msgRetornaAoMenuInicialConvenios

mainEditarConvenios :: IO()
mainEditarConvenios = do
    putStrLn "==============================================="
    Convenios.menuEditarConvenios
    voltaAoMenuAnterior mainConveniosAdmin msgRetornaAoMenuInicialConvenios

mainListarConvenios:: IO()
mainListarConvenios = do
  putStrLn "==============================================="
  listaConvenios
  voltaAoMenuAnterior mainConveniosAdmin msgRetornaAoMenuInicialConvenios
---------------------- Menu de Convênios (Cliente) -------------------------------

mainConveniosCliente:: IO()
mainConveniosCliente = do
  putStrLn "==============================================="
  listaConvenios
  putStrLn "==============================================="
  menuPrincipalCliente

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
  putStrLn "==============================================="
  ExamePronto.menuCadastrarExame
  voltaAoMenuAnterior mainExamesProntosAdmin msgRetornaAoMenuInicialExamesProntos 

mainEditarExamePronto::IO()
mainEditarExamePronto = do
  putStrLn "==============================================="
  ExamePronto.menuEditarExamePronto
  voltaAoMenuAnterior mainExamesProntosAdmin msgRetornaAoMenuInicialExamesProntos 

mainRemoveExamePronto::IO()
mainRemoveExamePronto = do
  putStrLn "==============================================="
  ExamePronto.menuRemoverExame 
  voltaAoMenuAnterior mainExamesProntosAdmin msgRetornaAoMenuInicialExamesProntos 

mainListarExamesProntos:: IO()
mainListarExamesProntos = do
  putStrLn "==============================================="
  ExamePronto.listarExamesProntos
  voltaAoMenuAnterior mainExamesProntosAdmin msgRetornaAoMenuInicialExamesProntos 

---------------------- Menus do modulo de Exames Prontos (Cliente) ------------------

mainExamesProntosCliente :: IO()
mainExamesProntosCliente = do
  putStrLn "==============================================="
  ExamePronto.menuVerificarExame
  putStrLn "==============================================="
  menuPrincipalCliente

--------------------------------- Menus do módulo de médicos (ADMIN) --------------------------
mainMedicosAdmin :: IO()
mainMedicosAdmin = do
    putStrLn "Ações disponíveis:\n"
    putStrLn "1 - Cadastrar Medico"
    putStrLn "2 - Listar Medicos"
    putStrLn "3 - Editar Medico"
    putStrLn "4 - Remover Medico"
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
  putStrLn "==============================================="
  Medico.menuAdicionarMedico
  voltaAoMenuAnterior mainMedicosAdmin msgRetornaAoMenuInicialExamesProntos

mainListarMedicos:: IO()
mainListarMedicos = do
  putStrLn "==============================================="
  Medico.listaDeMedicos
  voltaAoMenuAnterior mainMedicosAdmin msgRetornaAoMenuInicialExamesProntos 

mainEditarMedico:: IO()
mainEditarMedico = do
  putStrLn "==============================================="
  Medico.menuEditarMedico
  voltaAoMenuAnterior mainMedicosAdmin msgRetornaAoMenuInicialExamesProntos
 
mainRemoverMedico:: IO()
mainRemoverMedico = do
  putStrLn "==============================================="
  Medico.menuRemoverMedico
  voltaAoMenuAnterior mainMedicosAdmin msgRetornaAoMenuInicialExamesProntos

---------------------- Menus do módulo de Médicos (Cliente) ------------------------
mainMedicosCliente:: IO()
mainMedicosCliente = do
  putStrLn "==============================================="
  Medico.listaDeMedicos 
  putStrLn "==============================================="
  menuPrincipalCliente

---------------------- Menus do módulo de Avaliacao (Admin) ------------------------

mainAvaliacaoAdmin:: IO()
mainAvaliacaoAdmin = do
  putStrLn "==============================================="
  putStrLn "Avaliacoes:"
  Avaliacao.listaDeAvaliacoes
  putStrLn "==============================================="
  menuPrincipalAdmin

---------------------- Menus do módulo de Avaliacao (Cliente) ------------------------

mainAvaliacaoCliente:: IO()
mainAvaliacaoCliente = do
  putStrLn "Nos ajude a melhorar! Deixe sua avaliacao: "
  avaliacao <- getLine
  Avaliacao.escreverAvaliacao avaliacao
  putStrLn "Avaliacao registrada com sucesso. Muito obrigado!"
  menuPrincipalCliente

------------------- Menus do módulo de Exames (ADMIN) -----------------------------------------

mainAgendaAdmin:: IO()
mainAgendaAdmin = do
    putStrLn "Ações disponíveis:\n"
    putStrLn "1. Cadastrar uma agenda"
    putStrLn "2. Editar agenda existente"
    putStrLn "3. Remover agenda"
    putStrLn "Para voltar ao menu anterior, digite qualquer outro valor"
    selecao <- getLine
    case selecao of
        "1" -> mainCadastrarAgenda
        "2" -> mainEditarAgenda
        "3" -> mainRemoverAgenda
        _ -> menuPrincipalAdmin

mainCadastrarAgenda::IO()
mainCadastrarAgenda = do
    putStrLn "==============================================="
    Agenda.menuCadastrarAgenda 
    voltaAoMenuAnterior mainAgendaAdmin msgRetornaAoMenuInicialAgenda

mainEditarAgenda:: IO()
mainEditarAgenda = do
    putStrLn "==============================================="
    Agenda.menuEditarAgenda 
    voltaAoMenuAnterior mainAgendaAdmin msgRetornaAoMenuInicialAgenda

mainRemoverAgenda:: IO()
mainRemoverAgenda = do
    putStrLn "==============================================="
    Agenda.menuRemoverAgenda  
    voltaAoMenuAnterior mainAgendaAdmin msgRetornaAoMenuInicialAgenda

----------------- Menu do módulo de Exames (Cliente) -----------------------

mainAgendaCliente:: IO()
mainAgendaCliente = do
    putStrLn "==============================================="
    Agenda.menuAgendarVisita
    putStrLn "==============================================="
    menuPrincipalCliente

---------------- Menu do módulo de Exame Agendado (Admin) ------------------

mainExamesAgendadosAdmin:: IO()
mainExamesAgendadosAdmin = do
    putStrLn "Ações disponíveis:\n"
    putStrLn "1. Concluir um Exame Agendado"
    putStrLn "2. Cancelar um Exame Agendado"
    putStrLn "3. Editar um Exame Agendado"
    putStrLn "4. Listar Exames Agendados"
    putStrLn "Para voltar ao menu anterior, digite qualquer outro valor"
    selecao <- getLine
    case selecao of
        "1" -> mainConcluirExameAgendado
        "2" -> mainCancelarExameAgendado
        "3" -> mainEditarExameAgendado
        "4" -> mainListarExamesAgendados
        _ -> menuPrincipalAdmin

mainConcluirExameAgendado:: IO()
mainConcluirExameAgendado = do
  putStrLn "==============================================="
  ExameAgendado.menuConcluirExame
  voltaAoMenuAnterior mainExamesAgendadosAdmin msgRetornaAoMenuInicialExameAgendado

mainCancelarExameAgendado:: IO()
mainCancelarExameAgendado = do
  putStrLn "==============================================="
  ExameAgendado.menuCancelarExame
  voltaAoMenuAnterior mainExamesAgendadosAdmin msgRetornaAoMenuInicialExameAgendado

mainEditarExameAgendado:: IO()
mainEditarExameAgendado = do
  putStrLn "==============================================="
  ExameAgendado.menuEditarExameAgendado
  voltaAoMenuAnterior mainExamesAgendadosAdmin msgRetornaAoMenuInicialExameAgendado

mainListarExamesAgendados::IO()
mainListarExamesAgendados = do
    putStrLn "Refine melhor sua busca:"
    putStrLn "1. Listar todos os exames agendados"
    putStrLn "2. Listar exames agendados que estao em aberto"
    putStrLn "3. Listar exames concluidos"
    putStrLn "4. Listar exames agendados por dia"
    putStrLn "Para voltar ao menu anterior, digite qualquer outro valor"
    selecao <- getLine
    case selecao of
        "1" -> ExameAgendado.listarExames
        "2" -> ExameAgendado.listarExamesEmAberto 
        "3" -> ExameAgendado.listarExamesConcluidos 
        "4" -> mainListarExamesAgendadosPorDia
        _ -> mainExamesAgendadosAdmin
    voltaAoMenuAnterior mainExamesAgendadosAdmin msgRetornaAoMenuInicialExameAgendado

mainListarExamesAgendadosPorDia::IO()
mainListarExamesAgendadosPorDia = do
  putStrLn "Informe a data de busca [dd/mm/yyyy]"
  dia <- getLine
  ExameAgendado.listarExamesDia dia

---------------- Menu do módulo de Exame Agendado (Cliente) ------------------

mainAgendarExameCliente:: IO()
mainAgendarExameCliente = do
  putStrLn "==============================================="
  ExameAgendado.menuMarcarExame
  putStrLn "==============================================="
  menuPrincipalCliente

mainWelcomeMsg:: IO()
mainWelcomeMsg = do
  putStrLn "==============================================="
  putStrLn Home.welcomeMsg
  putStrLn "==============================================="
  menuPrincipalCliente