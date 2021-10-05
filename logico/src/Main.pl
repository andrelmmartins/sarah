:-use_module(library(csv)).
:-include('Exames.pl').
:-include('Convenio.pl').
:-include('Util.pl').
:-include('ExamePronto.pl').
:-include('Medico.pl').
:-include('Agenda.pl').
:-include('Avaliacoes.pl').
:-include('Home.pl').
:-include('ExameAgendado.pl').

main:-
  writeln(' *********** Seja Bem-vindo ao SARAH *********** '),
  writeln('1. Admin '),
  writeln('2. Paciente '),
  writeln('Para encerrar a sessao, digite qualquer outra tecla '),
  getString(Entrada, '-> '),
  (switch(Entrada, [
    "1": menuPrincipalAdmin,
    "2": menuPrincipalCliente
  ]);
  writeln('Encerrando a sessao. Volte sempre ao SARAH =)'), halt).
  
menuPrincipalAdmin:-
  writeln('Ola Admin! Qual modulo deseja acessar ?\n'),
  writeln('1. Medicos '),
  writeln('2. Convenios '),
  writeln('3. Exames '),
  writeln('4. Exames Prontos '),
  writeln('5. Agendamentos '),
  writeln('6. Avaliacoes '),
  writeln('7. Exames Agendados '),
  writeln('Para voltar ao menu principal, digite qualquer outra tecla.'),
  getString(Entrada, '-> '),
  (switch(Entrada, [
    "1": mainMedicosAdmin,
    "2": mainConveniosAdmin,
    "3": mainExamesAdmin,
    "4": mainExamesProntosAdmin,
    "5": mainAgendaAdmin,
    "6": mainAvaliacoesAdmin,
    "7": mainExamesAgendadosAdmin
  ]);
  main).

menuPrincipalCliente:-
  writeln('Ola! Em que a Sarah pode te ajudar hoje ?\n'),
  writeln('1. Buscar Medicos'),
  writeln('2. Buscar Convenios'),
  writeln('3. Buscar Exames disponiveis'),
  writeln('4. Buscar Resultados de Exames'),
  writeln('5. Agendar Visita'),
  writeln('6. Sugestoes, elogios e reclamAcoes'),
  writeln('7. Agendar Exame'),
  writeln('8. Conheca nossa clinica'),
  writeln('Para voltar ao menu principal, digite qualquer outra tecla.'),
  getString(Entrada, '-> '),
  (switch(Entrada, [
    "1": mainMedicosCliente,
    "2": mainConveniosCliente,
    "3": mainExamesCliente,
    "4": mainExamesProntosCliente,
    "5": mainAgendaCliente,
    "6": mainAvaliacoesCliente,
    "7": mainAgendarExameCliente,
    "8": mainWelcomeSarah
  ]);
  main).

%------------------- Menus do módulo de Exames (ADMIN) -----------------------------------------

mainAddExame:-
  writeln('==============================================='),
  menuCadastrarExame,
  writeln('==============================================='),
  writeln('Retornando ao menu inicial do modulo de exames.'),
  mainExamesAdmin.

mainBuscaExame:-
  writeln('==============================================='),
  menuBuscarExame,
  writeln('==============================================='),
  writeln('Retornando ao menu inicial do modulo de exames.'),
  mainExamesAdmin.

mainListarExames:-
  writeln('==============================================='),
  menuListarExames,
  writeln('==============================================='),
  writeln('Retornando ao menu inicial do modulo de exames.'),
  mainExamesAdmin.

mainEditarExame:-
  writeln('==============================================='),
  menuEditarExame,
  writeln('==============================================='),
  writeln('Retornando ao menu inicial do modulo de exames.'),
  mainExamesAdmin.

mainRemoverExame:-
  writeln('==============================================='),
  menuRemoverExame,
  writeln('==============================================='),
  writeln('Retornando ao menu inicial do modulo de exames.'),
  mainExamesAdmin.

mainExamesAdmin:-
  writeln('Acoes disponiveis:\n'),
  writeln('1. Cadastrar novo Exame'),
  writeln('2. Buscar um Exame a partir do seu nome'),
  writeln('3. Listar todos os exames cadastrados'),
  writeln('4. Editar Exame a partir do seu nome'),
  writeln('5. Remover um exame a partir do seu nome'),
  writeln('Para voltar ao menu anterior, digite qualquer outro valor'),
  getString(Entrada, '-> '),
  (switch(Entrada, [
    "1": mainAddExame,
    "2": mainBuscaExame,
    "3": mainListarExames,
    "4": mainEditarExame,
    "5": mainRemoverExame
  ]);
  menuPrincipalAdmin).

%----------------- Menu do módulo de Exames (Cliente) -----------------------

mainExamesCliente:-
  writeln('Acoes Disponiveis:\n'),
  writeln('1. Listar todos os exames cadastrados'),
  writeln('2. Buscar um Exame a partir do seu nome'),
  writeln('Para voltar ao menu anterior, digite qualquer outro valor'),
  getString(Entrada, '-> '),
  (switch(Entrada, [
    "1": mainListarExamesCliente,
    "2": mainBuscaExameCliente
  ]);
  menuPrincipalCliente).

mainBuscaExameCliente:-
  writeln('==============================================='),
  menuBuscarExame,
  writeln('==============================================='),
  writeln('Retornando ao menu do modulo de exames.'),
  mainExamesCliente.

mainListarExamesCliente:-
  writeln('==============================================='),
  menuListarExames,
  writeln('==============================================='),
  writeln('Retornando ao menu do modulo de exames.'),
  mainExamesCliente.

%----------------- Menus do módulo de convênios (ADMIN) ----------------------

mainConveniosAdmin:-
  writeln('Acoes disponiveis:\n'),
  writeln('1 - Cadastrar Convenio'),
  writeln('2 - Remover Convenio'),
  writeln('3 - Editar Convenio'),
  writeln('4 - Listar Convenios'),
  writeln('Para voltar ao menu anterior, digite qualquer outro valor\n'),
  getString(Entrada, '-> '),
  (switch(Entrada, [
    "1": mainAddConvenios,
    "2": mainRemoverConvenios,
    "3": mainEditarConvenios,
    "4": mainListarConvenios
  ]);
  menuPrincipalAdmin).

mainAddConvenios:-
  writeln('==============================================='),
  menuCadastrarConvenio,
  writeln('==============================================='),
  writeln('Retornando ao menu inicial do modulo de convenios.'),
  mainConveniosAdmin.

mainListarConvenios:-
  writeln('==============================================='),
  menuListarConvenios,
  writeln('==============================================='),
  writeln('Retornando ao menu inicial do modulo de convenios.'),
  mainConveniosAdmin.

mainEditarConvenios:-
  writeln('==============================================='),
  menuEditarConvenio,
  writeln('==============================================='),
  writeln('Retornando ao menu inicial do modulo de convenios.'),
  mainConveniosAdmin.

mainRemoverConvenios:-
  writeln('==============================================='),
  menuRemoverConvenio,
  writeln('==============================================='),
  writeln('Retornando ao menu inicial do modulo de convenios.'),
  mainConveniosAdmin.

%----------------- Menus do módulo de convênios (Cliente) ----------------------

mainConveniosCliente:-
  writeln('==============================================='),
  menuListarConvenios,
  writeln('==============================================='),
  writeln('Retornando ao menu principal do cliente.'),
  menuPrincipalCliente.

%---------------------- Menus do modulo de Exames Prontos (Admin) ------------------
mainExamesProntosAdmin:-
  writeln('Acoes disponiveis:\n'),
  writeln('1 - Cadastrar Exame Pronto'),
  writeln('2 - Editar Exame Pronto'),
  writeln('3 - Remover Exame Pronto'),
  writeln('4 - Listar Exames Prontos'),
  writeln('5 - Buscar Exame Pronto'),
  writeln('Para voltar ao menu anterior, digite qualquer outro valor'),
  getString(Entrada, '-> '),
  (switch(Entrada, [
    "1": mainCadastrarExamePronto,
    "2": mainEditarExamePronto,
    "3": mainRemoveExamePronto,
    "4": mainListarExamesProntos,
    "5": mainBuscarExamePronto
  ]);
  menuPrincipalAdmin).

mainCadastrarExamePronto:-
  writeln('==============================================='),
  menuCadastrarExamePronto,
  writeln('==============================================='),
  writeln('Retornando ao menu inicial do modulo de exames prontos.'),
  mainExamesProntosAdmin.

mainListarExamesProntos:-
  writeln('==============================================='),
  menuListarExamesProntos,
  writeln('==============================================='),
  writeln('Retornando ao menu inicial do modulo de exames prontos.'),
  mainExamesProntosAdmin.

mainEditarExamePronto:-
  writeln('==============================================='),
  menuEditarExamePronto,
  writeln('==============================================='),
  writeln('Retornando ao menu inicial do modulo de exames prontos.'),
  mainExamesProntosAdmin.

mainRemoveExamePronto:-
  writeln('==============================================='),
  menuRemoverExamePronto,
  writeln('==============================================='),
  writeln('Retornando ao menu inicial do modulo de exames prontos.'),
  mainExamesProntosAdmin.

mainBuscarExamePronto:-
  writeln('==============================================='),
  menuBuscarExamePronto,
  writeln('==============================================='),
  writeln('Retornando ao menu inicial do modulo de exames prontos.'),
  mainExamesProntosAdmin.

%---------------------- Menus do modulo de Exames Prontos (Cliente) ------------------

mainExamesProntosCliente:-
  writeln('==============================================='),
  menuAcessarExamePronto,
  writeln('==============================================='),
  writeln('Retornando ao menu principal do cliente.'),
  menuPrincipalCliente.

%--------------------------------- Menus do módulo de médicos (ADMIN) --------------------------
mainMedicosAdmin:-
  writeln('Acoes disponiveis:\n'),
  writeln('1 - Cadastrar Medico'),
  writeln('2 - Editar Medico'),
  writeln('3 - Remover Medico'),
  writeln('4 - Listar Medicos'),
  writeln('Para voltar ao menu anterior, digite qualquer outro valor'),
  getString(Entrada, '-> '),
  (switch(Entrada, [
    "1": mainCadastrarMedico,
    "2": mainEditarMedico,
    "3": mainRemoverMedico,
    "4": mainListarMedicos
  ]);
  menuPrincipalAdmin).

mainCadastrarMedico:-
  writeln('==============================================='),
  menuCadastrarMedico,
  writeln('==============================================='),
  writeln('Retornando ao menu inicial do modulo de medicos.'),
  mainMedicosAdmin.

mainListarMedicos:-
  writeln('==============================================='),
  menuListarMedicos,
  writeln('==============================================='),
  writeln('Retornando ao menu inicial do modulo de medicos.'),
  mainMedicosAdmin. 

mainEditarMedico:-
  writeln('==============================================='),
  menuEditarMedico,
  writeln('==============================================='),
  writeln('Retornando ao menu inicial do modulo de medicos.'),
  mainMedicosAdmin.
 
mainRemoverMedico:-
  writeln('==============================================='),
  menuRemoverMedico,
  writeln('==============================================='),
  writeln('Retornando ao menu inicial do modulo de medicos.'),
  mainMedicosAdmin.

%---------------------- Menus do módulo de Médicos (Cliente) ------------------------
mainMedicosCliente:-
  writeln('==============================================='),
  menuListarMedicos,
  writeln('==============================================='),
  writeln('Retornando ao menu principal do cliente.'),
  menuPrincipalCliente.


%------------------- Menus do módulo de Agenda (ADMIN) -----------------------------------------

mainAgendaAdmin:-
  writeln('Acoes disponiveis:\n'),
  writeln('1. Cadastrar uma agenda'),
  writeln('2. Editar agenda existente'),
  writeln('3. Remover agenda'),
  writeln('4. Buscar agenda para uma data'),
  writeln('5. Listar agendas cadastradas'),
  writeln('Para voltar ao menu anterior, digite qualquer outro valor'),
  getString(Entrada, '-> '),
  (switch(Entrada, [
    "1": mainCadastrarAgenda,
    "2": mainEditarAgenda,
    "3": mainRemoverAgenda,
    "4": mainBuscarAgenda,
    "5": mainListarAgenda
  ]);
  menuPrincipalAdmin).

mainCadastrarAgenda:-
  writeln('==============================================='),
  menuCadastrarAgenda,
  writeln('==============================================='),
  writeln('Retornando ao menu inicial do modulo de agenda.'),
  mainAgendaAdmin.

mainEditarAgenda:-
  writeln('==============================================='),
  menuEditarAgenda,
  writeln('==============================================='),
  writeln('Retornando ao menu inicial do modulo de agenda.'),
  mainAgendaAdmin.

mainRemoverAgenda:-
  writeln('==============================================='),
  menuRemoverAgenda,
  writeln('==============================================='),
  writeln('Retornando ao menu inicial do modulo de agenda.'),
  mainAgendaAdmin.

mainBuscarAgenda:-
  writeln('==============================================='),
  menuBuscarAgenda,
  writeln('==============================================='),
  writeln('Retornando ao menu inicial do modulo de agenda.'),
  mainAgendaAdmin.

mainListarAgenda:-
  writeln('==============================================='),
  menuListarAgendas,
  writeln('==============================================='),
  writeln('Retornando ao menu inicial do modulo de agenda.'),
  mainAgendaAdmin.

%----------------- Menu do módulo de Agenda (Cliente) -----------------------

mainAgendaCliente:-
  writeln('Acoes Disponiveis:\n'),
  writeln('1. Agendar visita'),
  writeln('2. Cancelar visita'),
  writeln('Para voltar ao menu anterior, digite qualquer outro valor'),
  getString(Entrada, '-> '),
  (switch(Entrada, [
    "1": mainAgendarVisitaCliente,
    "2": mainCancelarVisitaCliente
  ]);
  menuPrincipalCliente).

mainAgendarVisitaCliente:-
  writeln('==============================================='),
  menuAgendarVisita,
  writeln('==============================================='),
  writeln('Retornando ao menu de agendamentos.'),
  mainAgendaCliente.

mainCancelarVisitaCliente:-
  writeln('==============================================='),
  menuCancelarVisita,
  writeln('==============================================='),
  writeln('Retornando ao menu de agendamentos.'),
  mainAgendaCliente.

%----------------- Menu do módulo de AvaliAcoes (Admini -----------------------

mainAvaliacoesAdmin:-
  writeln('==============================================='),
  menuListarAvaliacoes,
  writeln('==============================================='),
  writeln('Retornando ao menu de principal do Admin.'),
  menuPrincipalAdmin.

%----------------- Menu do módulo de AvaliAcoes (Clienie) -----------------------

mainAvaliacoesCliente:-
  writeln('==============================================='),
  menuCadastrarAvaliacao,
  writeln('==============================================='),
  writeln('Retornando ao menu de principal do Cliente.'),
  menuPrincipalCliente.

%----------------- Menu do módulo de Exame Agendado (Admin) -----------------------

mainExamesAgendadosAdmin:-
  writeln('Acoes disponiveis:\n'),
  writeln('1. Concluir um Exame Agendado'),
  writeln('2. Cancelar um Exame Agendado'),
  writeln('3. Editar um Exame Agendado'),
  writeln('4. Listar Exames Agendados'),
  writeln('Para voltar ao menu anterior, digite qualquer outro valor'),
  getString(Entrada, '-> '),
  (switch(Entrada, [
    "1": mainConcluirExameAgendado,
    "2": mainCancelarExameAgendado,
    "3": mainEditarExameAgendado,
    "4": mainListarExamesAgendados
  ]);
  menuPrincipalAdmin).

mainConcluirExameAgendado:-
  writeln('==============================================='),
  menuConcluirExame,
  writeln('==============================================='),
  writeln('Retornando ao menu do modulo de Exames Agendados.'),
  mainExamesAgendadosAdmin.

mainCancelarExameAgendado:-
  writeln('==============================================='),
  menuCancelarExame,
  writeln('==============================================='),
  writeln('Retornando ao menu do modulo de Exames Agendados.'),
  mainExamesAgendadosAdmin.

mainEditarExameAgendado:-
  writeln('==============================================='),
  menuEditarExameAgendado,
  writeln('==============================================='),
  writeln('Retornando ao menu do modulo de Exames Agendados.'),
  mainExamesAgendadosAdmin.

mainListarExamesAgendados:-
  writeln('Refine melhor sua busca:'),
  writeln('1. Listar todos os exames agendados'),
  writeln('2. Listar exames agendados que estao em aberto'),
  writeln('3. Listar exames concluidos'),
  writeln('4. Listar exames agendados por dia'),
  writeln('Para voltar ao menu anterior, digite qualquer outro valor'),
  getString(Entrada, '-> '),
  (switch(Entrada, [
    "1": mainListarTodosExamesAgendados,
    "2": mainListarExamesAgendadosEmAberto,
    "3": mainListarExamesAgendadosConcluidos,
    "4": mainListarExamesAgendadosPorDia
  ]);
  mainExamesAgendadosAdmin).

mainListarTodosExamesAgendados:-
  writeln('==============================================='),
  menuListarExamesAgendados,
  writeln('==============================================='),
  writeln('Retornando ao menu de Listagem de Exames Agendados.'),
  mainListarExamesAgendados.

mainListarExamesAgendadosEmAberto:-
  writeln('==============================================='),
  menuListarExamesEmAberto,
  writeln('==============================================='),
  writeln('Retornando ao menu de Listagem de Exames Agendados.'),
  mainListarExamesAgendados.

mainListarExamesAgendadosConcluidos:-
  writeln('==============================================='),
  menuListarExamesConcluidos,
  writeln('==============================================='),
  writeln('Retornando ao menu de Listagem de Exames Agendados.'),
  mainListarExamesAgendados.

mainListarExamesAgendadosPorDia:-
  writeln('==============================================='),
  menuListarExamesPelaData,
  writeln('==============================================='),
  writeln('Retornando ao menu de Listagem de Exames Agendados.'),
  mainListarExamesAgendados.

%---------------- Menu do módulo de Exame Agendado (Cliente) ------------------

mainAgendarExameCliente:-
  writeln('==============================================='),
  menuMarcarExame,
  writeln('==============================================='),
  writeln('Retornando ao menu de principal do Cliente.'),
  menuPrincipalCliente.

%----------------- Conheça nossa Clinica!! -----------------------

mainWelcomeSarah:-
  writeln('==============================================='),
  welcomeMsg,
  writeln('==============================================='),
  writeln('Retornando ao menu de principal do Cliente.'),
  menuPrincipalCliente.
