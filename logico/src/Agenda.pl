:-use_module(library(csv)).
:-include('Util.pl').

%---------------------------- Cadastrar uma Agenda -----------------------------------

cadastrarAgenda(Data, Horario1, Horario2, Horario3, Horario4, Horario5) :-
    open('../db/Agendas.csv', append, File),
    writeln(File, (Data, Horario1, Horario2, Horario3, Horario4, Horario5)),                 
    close(File).

%---------------------------- Buscar uma Agenda ----------------------------

buscarAgenda(Data, Encontrada) :-
    (exists_file('../db/Agendas.csv') -> (lerCsvRowList('../db/Agendas.csv', Agendas),
    buscaAgendaEmLista(Data, Agendas, Encontrada));
    Encontrada = []).

buscaAgendaEmLista(_, [], []).
buscaAgendaEmLista(Data, [Atual | Restante], Encontrada) :-
    nth0(0, Atual, X),
    (atom_string(X, Data) -> Encontrada = Atual;
    buscaAgendaEmLista(Data, Restante, Encontrada)).
    
%---------------------------- Listar Agendas ---------------------------

listarAgendas :-
    lerCsvRowList('../db/Agendas.csv', Agendas),
    printaAgenda(Agendas).

printaAgenda([]).
printaAgenda([Agenda | Restante]) :- 
    toString(Agenda, String),
    writeln(String),
    printaAgenda(Restante).

%---------------------------- Remover uma Agenda ---------------------------

removerAgenda(Data) :-
    lerCsvRowList('../db/Agendas.csv', Agendas),
    buscarAgenda(Data, Encontrada),
    delete(Agendas, Encontrada, AgendasResultantes),
    delete_file('../db/Agendas.csv'),
    open('../db/Agendas.csv', append, File),
    insereAgendas(AgendasResultantes),
    close(File).

insereAgendas([]).
insereAgendas([Agenda | Restante]) :-
    nth0(0, Agenda, Data),
    nth0(1, Agenda, Horario1),
    nth0(2, Agenda, Horario2),
    nth0(3, Agenda, Horario3),
    nth0(4, Agenda, Horario4),
    nth0(5, Agenda, Horario5),
    cadastrarAgenda(Data, Horario1, Horario2, Horario3, Horario4, Horario5),
    insereAgendas(Restante).

%---------------------------- Editar uma Agenda ---------------------------

editarAgenda(Data, NovaData, Horario1, Horario2, Horario3, Horario4, Horario5) :-
    removerAgenda(Data),
    cadastrarAgenda(NovaData, Horario1, Horario2, Horario3, Horario4, Horario5).

%---------------------------- Agendar Visita ---------------------------

agendarVisita(Data, Horario) :-
    buscarAgenda(Data, Encontrada),
    proper_length(Encontrada, Tamanho),
    (Tamanho =:= 0 -> (cadastrarAgenda(Data, 1, 0, 0, 0, 0),
                       Horario = '08h as 10h');
        (nth0(1, Encontrada, Horario1),
        nth0(2, Encontrada, Horario2),
        nth0(3, Encontrada, Horario3),
        nth0(4, Encontrada, Horario4),
        nth0(5, Encontrada, Horario5),
        (Horario1 < 30 -> (Reserva is Horario1 + 1,
                          editarAgenda(Data, Data, Reserva, Horario2, Horario3, Horario4, Horario5),
                          Horario = '08h as 10h');
        Horario2 < 30 -> (Reserva is Horario2 + 1,
                          editarAgenda(Data, Data, Horario1, Reserva, Horario3, Horario4, Horario5),
                          Horario = '10h as 12h');
        Horario3 < 30 -> (Reserva is Horario3 + 1,
                          editarAgenda(Data, Data, Horario1, Horario2, Reserva, Horario4, Horario5),
                          Horario = '12h as 14h');
        Horario4 < 30 -> (Reserva is Horario4 + 1,
                          editarAgenda(Data, Data, Horario1, Horario2, Horario3, Reserva, Horario5),
                          Horario = '14h as 16h');
        Horario5 < 30 -> (Reserva is Horario5 + 1,
                          editarAgenda(Data, Data, Horario1, Horario2, Horario3, Horario4, Reserva),
                          Horario = '16h as 18h');
        Horario = '0'))).

%---------------------------- Cancelar uma Visita ---------------------------

cancelarVisita(Data, Horario, Resultado) :-
    buscarAgenda(Data, Encontrada),
    proper_length(Encontrada, Tamanho),
    (Tamanho =:= 0 -> writeln('\nNao nenhuma agenda para este dia!');
        (nth0(1, Encontrada, Horario1),
        nth0(2, Encontrada, Horario2),
        nth0(3, Encontrada, Horario3),
        nth0(4, Encontrada, Horario4),
        nth0(5, Encontrada, Horario5),
        ((Horario = "08h as 10h", Horario1 > 0) -> (Reserva is Horario1 - 1,
                          editarAgenda(Data, Data, Reserva, Horario2, Horario3, Horario4, Horario5),
                          Resultado = true);
        (Horario = "10h as 12h", Horario2 > 0) -> (Reserva is Horario2 - 1,
                          editarAgenda(Data, Data, Horario1, Reserva, Horario3, Horario4, Horario5),
                          Resultado = true);
        (Horario = "12h as 14h", Horario3 > 0) -> (Reserva is Horario3 - 1,
                          editarAgenda(Data, Data, Horario1, Horario2, Reserva, Horario4, Horario5),
                          Resultado = true);
        (Horario = "14h as 16h", Horario4 > 0) -> (Reserva is Horario4 - 1,
                          editarAgenda(Data, Data, Horario1, Horario2, Horario3, Reserva, Horario5),
                          Resultado = true);
        (Horario = "16h as 18h", Horario5 > 0) -> (Reserva is Horario5 - 1,
                          editarAgenda(Data, Data, Horario1, Horario2, Horario3, Horario4, Reserva),
                          Resultado = true);
        Resultado = false))).

%---------------------------- Menus ---------------------------

menuBuscarAgenda :-
    (seNaoTemAgendas -> write('Nao ha Agendas cadastradas para buscar!');
    (write('\n'),
    getString(Data, 'Qual a Data da Agenda que vamos buscar? [dd/MM/yyyy]: '),
    buscarAgenda(Data, Encontrada),
    writeln(Encontrada))).

menuListarAgendas :-
    (seNaoTemAgendas -> write('Nao ha Agendas cadastradas para listar!');
    (writeln('\nEsses sao as Agendas no sistema: \n'),
    listarAgendas)).

menuEditarAgenda :-
    (seNaoTemAgendas -> writeln('Nao ha Agendas cadastradas para editar!');
    (write('\n'),
    getString(Data, 'Qual a Data da Agenda que vai ser editada? [dd/MM/yyyy]: '),
    buscarAgenda(Data, Encontrada),
    proper_length(Encontrada, Tamanho),
    (Tamanho =:= 0 -> writeln('Essa Agenda nao existe no sistema!');
        (getString(NovaData, 'Qual a Nova Data para essa Agenda? [dd/MM/yyyy]: '),
        buscarAgenda(NovaData, Encontrada2),
        proper_length(Encontrada2, Tamanho2),
        ((Tamanho2 > 0, Data \= NovaData) -> writeln('Ja existe uma agenda com essa Data!');
            (getString(Horario1, 'Informe a quantidade de visitas das 08h as 10h: [0 a 30]: '),
            getString(Horario2, 'Informe a quantidade de visitas das 10h as 12h: [0 a 30]: '),
            getString(Horario3, 'Informe a quantidade de visitas das 12h as 14h: [0 a 30]: '),
            getString(Horario4, 'Informe a quantidade de visitas das 14h as 16h: [0 a 30]: '),
            getString(Horario5, 'Informe a quantidade de visitas das 16h as 18h: [0 a 30]: '),
            editarAgenda(Data, NovaData, Horario1, Horario2, Horario3, Horario4, Horario5),
            writeln('\nAgenda Editada!'))))))).

menuRemoverAgenda :-
    (seNaoTemAgendas -> write('Nao ha Agendas cadastradas para remover!');
    (write('\n'),
    getString(Data, 'Qual a Data da Agenda que vai ser removida? [dd/MM/yyyy]: '),
    buscarAgenda(Data, Encontrada),
    proper_length(Encontrada, Tamanho),
    (Tamanho =:= 0 -> writeln('Agenda nao existe no sistema!');
        removerAgenda(Data),
        write('Agenda Removida!')))).

menuCadastrarAgenda :-
    write('\n'),
    getString(Data, 'Qual a Data que vai referenciar a Agenda? [dd/MM/yyyy]: '),
    buscarAgenda(Data, Encontrada),
    proper_length(Encontrada, Tamanho),
    (Tamanho > 0 -> writeln('Ja existe uma Agenda com essa data!'); 
        (cadastrarAgenda(Data, 0, 0, 0, 0, 0),
        writeln('Agenda Cadastrada!'))).

menuAgendarVisita :-
    write('\n'),
    getString(Data, 'Que data voce pretende visitar nossa clinica? [dd/MM/yyyy]: '),
    agendarVisita(Data, Horario),
    (Horario = '0' -> writeln('Nao existe mais vaga neste dia!');
    (atomic_list_concat(['\nVoce foi agendado para ', Data, ' as ', Horario, '!'], String),
    write(String))).

%---------------------------- Métodos Extra ---------------------------

toString(List, String) :-
    nth0(0, List, Data),
    nth0(1, List, Horario1),
    nth0(2, List, Horario2),
    nth0(3, List, Horario3),
    nth0(4, List, Horario4),
    nth0(5, List, Horario5),
    Lista = ['---------------------------------- ', Data, ' ----------------------------------\n', '8h as 10h: ', Horario1, ' | 10h as 12h: ', Horario2, ' | 12h as 14h: ', Horario3, ' | 14h as 16h: ', Horario4, ' | 16h as 18h: ', Horario5],
    atomic_list_concat(Lista, String).


seNaoTemAgendas:-
    lerCsvRowList('../db/Agendas.csv', Agendas),
    proper_length(Agendas, Tamanho),
    Tamanho =:= 0.