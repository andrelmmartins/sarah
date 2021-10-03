:-use_module(library(csv)).
:-include('Exames.pl').
:-include('Convenio.pl').
:-include('Util.pl').

main:-
  writeln(' *********** Seja Bem-vindo ao SARAH *********** '),
  writeln('1. Admin '),
  writeln('2. Paciente '),
  writeln('Para encerrar a sessão, digite qualquer outra tecla '),
  getString(Entrada, '-> '),
  (switch(Entrada, [
    "1": menuPrincipalAdmin,
    "2": menuPrincipalCliente
  ]);
  writeln('Encerrando a sessao. Volte sempre ao SARAH =)'), halt).
  
menuPrincipalAdmin:-
  writeln('Olá Admin! Qual módulo deseja acessar ?\n'),
  writeln('1. Médicos '),
  writeln('2. Convênios '),
  writeln('3. Exames '),
  writeln('4. Exames Prontos '),
  writeln('5. Agendamentos '),
  writeln('6. Avaliações '),
  writeln('7. Exames Agendados '),
  writeln('Para voltar ao menu principal, digite qualquer outra tecla.'),
  getString(Entrada, '-> '),
  (switch(Entrada, [
    "1": writeln('Entrada 1'),
    "2": mainConveniosAdmin,
    "3": mainExamesAdmin,
    "4": writeln('Entrada 4'),
    "5": writeln('Entrada 5'),
    "6": writeln('Entrada 6'),
    "7": writeln('Entrada 7')
  ]);
  main).

menuPrincipalCliente:-
  writeln('Olá! Em que a Sarah pode te ajudar hoje ?\n'),
  writeln('1. Buscar Medicos'),
  writeln('2. Buscar Convenios'),
  writeln('3. Buscar Exames disponiveis'),
  writeln('4. Buscar Resultados de Exames'),
  writeln('5. Agendar Visita'),
  writeln('6. Sugestões, elogios e reclamações'),
  writeln('7. Agendar Exame'),
  writeln('8. Conheca nossa clinica'),
  writeln('Para voltar ao menu principal, digite qualquer outra tecla.'),
  getString(Entrada, '-> '),
  (switch(Entrada, [
    "1": writeln('Entrada 1'),
    "2": writeln('Entrada 2'),
    "3": mainExamesCliente,
    "4": writeln('Entrada 4'),
    "5": writeln('Entrada 5'),
    "6": writeln('Entrada 6'),
    "7": writeln('Entrada 7'),
    "8": writeln('Entrada 8')
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
  writeln('Ações disponíveis:\n'),
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
  writeln('Ações Disponíveis:\n'),
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
  writeln('Ações disponíveis:\n'),
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