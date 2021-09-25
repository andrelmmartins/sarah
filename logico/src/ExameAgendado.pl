:-use_module(library(csv)).
:-consult('ExamePronto.pl').

%---------------------------- Marcar um Exame -----------------------------------

marcarExame(ID, CrmMedico, NomeMedico, NomeExame, Data, Hora, Status) :-
    open('../db/ExamesAgendados.csv', append, File),
    writeln(File, (ID, CrmMedico, NomeMedico, NomeExame, Data, Hora, Status)),                 
    close(File).

%---------------------------- Buscar um Exame ----------------------------

buscaExame(ID, Encontrado) :-
    (exists_file('../db/ExamesAgendados.csv') -> (lerCsvRowList('../db/ExamesAgendados.csv', ExamesAgendados),
    buscaExameAgendadoEmLista(ID, ExamesAgendados, Encontrado));
    Encontrado = []).

buscaExameAgendadoEmLista(_, [], []).
buscaExameAgendadoEmLista(ID, [Atual | Restante], Encontrado) :-
    atom_number(ID, Number),
    (nth0(0, Atual, Number) -> Encontrado = Atual;
    buscaExameAgendadoEmLista(ID, Restante, Encontrado)).

%---------------------------- Listar Exames Prontos ---------------------------

listarExamesAgendados :-
    lerCsvRowList('../db/ExamesAgendados.csv', ExamesAgendados),
    printaExameAgendado(ExamesAgendados).

listarExamesEmAberto :-
    lerCsvRowList('../db/ExamesAgendados.csv', ExamesAgendados),
    delete(ExamesAgendados, [_, _, _, _, _, _, 'Concluido'], ExamesResultantes),
    printaExameAgendado(ExamesResultantes).

listarExamesConcluidos :-
    lerCsvRowList('../db/ExamesAgendados.csv', ExamesAgendados),
    delete(ExamesAgendados, [_, _, _, _, _, _, 'Em Aberto'], ExamesResultantes),
    printaExameAgendado(ExamesResultantes).

listarExamesPelaData(X, ExamesDaData) :-
    lerCsvRowList('../db/ExamesAgendados.csv', ExamesAgendados),
    atom_string(Data, X),
    delete(ExamesAgendados, [_, _, _, _, Data, _, _], ExamesResultantes),
    separaExames(ExamesResultantes, ExamesAgendados, ExamesDaData).

separaExames([], ExamesResultantes, ExamesDaData) :-
    ExamesDaData = ExamesResultantes.
separaExames([Atual | Restante], ExamesAgendados, ExamesDaData) :-
    nth0(4, Atual, Data),
    delete(ExamesAgendados, [_, _, _, _, Data, _, _], ExamesResultantes),
    separaExames(Restante, ExamesResultantes, ExamesDaData).

printaExameAgendado([]).
printaExameAgendado([Exame | Restante]) :- 
    toStringAgendado(Exame, String),
    writeln(String),
    printaExameAgendado(Restante).

%---------------------------- Remover Exame Pronto ---------------------------

cancelarExame(ID) :-
    lerCsvRowList('../db/ExamesAgendados.csv', ExamesAgendados),
    atom_number(ID, Number),
    delete(ExamesAgendados, [Number, _, _, _, _, _, _], ExamesResultantes),
    delete_file('../db/ExamesAgendados.csv'),
    open('../db/ExamesAgendados.csv', append, File),
    insereExamesAgendados(ExamesResultantes),
    close(File).

insereExamesAgendados([]).
insereExamesAgendados([Exame | Restante]) :-
    nth0(0, Exame, ID),
    nth0(1, Exame, CrmMedico),
    nth0(2, Exame, NomeMedico),
    nth0(3, Exame, NomeExame),
    nth0(4, Exame, Data),
    nth0(5, Exame, Hora),
    nth0(6, Exame, Status),
    marcarExame(ID, CrmMedico, NomeMedico, NomeExame, Data, Hora, Status),
    insereExamesAgendados(Restante).

%---------------------------- Editar Exame Pronto ---------------------------

editarExameAgendado(ID, CrmMedico, NomeMedico, NomeExame, Data, Hora, Status) :-
    cancelarExame(ID),
    marcarExame(ID, CrmMedico, NomeMedico, NomeExame, Data, Hora, Status).

%---------------------------- Concluir Exame ---------------------------

concluirExame(ID, SenhaEncriptada, Link) :-
    buscaExame(ID, Encontrado),
    nth0(1, Encontrado, CrmMedico),
    nth0(2, Encontrado, NomeMedico),
    nth0(3, Encontrado, NomeExame),
    nth0(4, Encontrado, Data),
    nth0(5, Encontrado, Hora),
    editarExameAgendado(ID, CrmMedico, NomeMedico, NomeExame, Data, Hora, "Concluido"),
    cadastraExamePronto(ID, SenhaEncriptada, Link).

%---------------------------- Menus ---------------------------

menuListarExamesAgendados :-
    (seNaoTemExamesAgendados -> writeln('\nNao ha Exames cadastrados para listar!');
        (writeln('\nEsses sao os Exames Agendados cadastrados no sistema: \n'),
        listarExamesAgendados)).

menuListarExamesEmAberto :-
    (seNaoTemExamesAgendados -> writeln('\nNao ha Exames Em Aberto no sistema!');
        (writeln('\nEsses sao os Exames Em Aberto no sistema: \n'),
        listarExamesEmAberto)).

menuListarExamesConcluidos :-
    (seNaoTemExamesAgendados -> writeln('\nNao ha Exames Concluidos no sistema!');
        (writeln('\nEsses sao os Exames Concluidos no sistema: \n'),
        listarExamesConcluidos)).

menuListarExamesPelaData :-
    (seNaoTemExamesAgendados -> writeln('\nNao ha Exames cadastrados para listar!');
        (getString(Data, 'Qual a data voce deseja ver os exames? [dd/MM/yyyy]: '),
        listarExamesPelaData(Data, ExamesDaData),
        (ExamesDaData = [] -> writeln('\nNao ha Exames Agendados nesta data!');
            (writeln('\nEsses sao os Exames Agedados nesta data: \n'),
            printaExameAgendado(ExamesDaData))))).

menuEditarExameAgendado :-
    (seNaoTemExamesAgendados -> writeln('\nNao ha nenhum Exame cadastrado para editar');
        (getString(ID, 'Informe o ID do Exame que vai ser editado: '),
        buscaExame(ID, Encontrado),
        (Encontrado = [] -> writeln('Esse exame nao existe no sistema!');
            (lerCsvRowList('../db/Exames.csv', Exames),
            writeln('\nExames:'),
            printaComIndice(Exames, 0, 0),
            getInt(IndiceExame, '> Dentre os exames listados, digite o numero de qual voce pretende marcar? '),
            proper_length(Exames, Tamanho1),
            ((IndiceExame < 0, IndiceExame >= Tamanho1) -> writeln('Esse exame nao esta na lista');
                nth0(IndiceExame, Exames, [NomeExame | _]),
                getString(Data, '\nQual a Data voce pretende fazer o exame? [dd/MM/yyyy]: '),
                lerCsvRowList('../db/Medicos.csv', Medicos),
                (Medicos = [] -> writeln('Nao temos medicos disponiveis para agendar.');
                    (writeln('\nMedicos:'),
                    printaComIndice(Medicos, 1, 0),
                    getInt(IndiceMedicos, '> Dentre os medicos listados, digite o numero de qual voce deseja ser atendido? '),
                    proper_length(Medicos, Tamanho2),
                    ((IndiceMedicos < 0, IndiceMedicos >= Tamanho2) -> writeln('Esse medico nao esta na lista');
                        nth0(IndiceMedicos, Medicos, [CrmMedico, NomeMedico | _]),
                        montaHorariosMedico(CrmMedico, Data, Horarios),
                        (Horarios = [] -> writeln('Esse medico esta com a agenda cheia neste dia.');
                            writeln('\nHorarios:'),
                            printaComIndice(Horarios, 0),
                            getInt(IndiceHora, '> Dentre os horarios listados, digite o numero para qual você pretende agendar? '),
                            proper_length(Horarios, Tamanho3),
                            ((IndiceHora < 0, IndiceHora >= Tamanho3) -> writeln('Esse horario nao esta na lista');
                                nth0(IndiceHora, Horarios, Hora),
                                writeln('\nStatus:'),
                                printaComIndice(['Concluido', 'Em Aberto'], 0),
                                getInt(IndiceStatus, '> Dentre os status, qual o status desse exame? '),
                                ((IndiceStatus < 0, IndiceStatus >= 2) -> writeln('Esse status nao esta na lista');
                                    nth0(IndiceStatus, ['Concluido', 'Em Aberto'], Status),
                                    editarExameAgendado(ID, CrmMedico, NomeMedico, NomeExame, Data, Hora, Status),
                                    write('\nExame editado com sucesso! > Codigo: '), write(ID), write(' | '), write(NomeExame), write(' | Medico: '), write(NomeMedico), write(' | '), write(Data), write(' as '), write(Hora), write(' | '), write(Status)))))))))))).

menuMarcarExame :-
    lerCsvRowList('../db/Exames.csv', Exames),
    (Exames = [] -> writeln('Nao temos exames disponiveis para agendar.');
        (writeln('\nExames:'),
        printaComIndice(Exames, 0, 0),
        getInt(IndiceExame, '> Dentre os exames listados, digite o numero de qual voce pretende marcar? '),
        proper_length(Exames, Tamanho1),
        ((IndiceExame < 0, IndiceExame >= Tamanho1) -> writeln('Esse exame nao esta na lista');
            nth0(IndiceExame, Exames, [NomeExame | _]),
            getString(Data, '\nQual a Data voce pretende fazer o exame? [dd/MM/yyyy]: '),
            lerCsvRowList('../db/Medicos.csv', Medicos),
            (Medicos = [] -> writeln('Nao temos medicos disponiveis para agendar.');
                (writeln('\nMedicos:'),
                printaComIndice(Medicos, 1, 0),
                getInt(IndiceMedicos, '> Dentre os medicos listados, digite o numero de qual voce deseja ser atendido? '),
                proper_length(Medicos, Tamanho2),
                ((IndiceMedicos < 0, IndiceMedicos >= Tamanho2) -> writeln('Esse medico nao esta na lista');
                    nth0(IndiceMedicos, Medicos, [CrmMedico, NomeMedico | _]),
                    montaHorariosMedico(CrmMedico, Data, Horarios),
                    (Horarios = [] -> writeln('Esse medico esta com a agenda cheia neste dia.');
                        nth0(0, Horarios, Hora),
                        pegaProximoID(ID),
                        marcarExame(ID, CrmMedico, NomeMedico, NomeExame, Data, Hora, 'Em Aberto'),
                        write('\nExame marcado com sucesso! > Codigo: '), write(ID), write(' | '), write(NomeExame), write(' | Medico: '), write(NomeMedico), write(' | '), write(Data), write(' as '), writeln(Hora)))))))).


menuCancelarExame :-
    getString(ID, '\nQual o ID do Exame que vai ser cancelado? '),
    buscaExame(ID, Encontrado),
    (Encontrado = [] -> writeln('Esse exame nao existe no sistema!');
        (cancelarExame(ID),
        writeln('Exame cancelado!'))).

menuConcluirExame :-
    getString(ID, '\nQual o ID do Exame que vai ser concluido? '),
    buscaExame(ID, Encontrado),
    (Encontrado = [] -> writeln('Esse exame nao existe no sistema!');
        (getString(Senha, 'Defina uma senha para que o paciente possa acessar este exame: '),
        encripta(Senha, Encriptada),
        getString(Link, 'Informe o Link do Resultado do Exame do Paciente: '),
        (re_match('https://', Link) -> (concluirExame(ID, Encriptada, Link),
                                        writeln('Exame Concluido e disponivel para o Paciente!'));
            writeln('Este link nao e valido.')))).

%---------------------------- Métodos Extra ---------------------------

toStringAgendado(List, String) :-
    nth0(0, List, ID),
    nth0(1, List, CrmMedico),
    nth0(2, List, NomeMedico),
    nth0(3, List, NomeExame),
    nth0(4, List, Data),
    nth0(5, List, Hora),
    nth0(6, List, Status),
    atomic_list_concat([ID, ' | ', NomeExame, ' | ', NomeMedico, ' / ', CrmMedico, ' | ', Data, ' - ', Hora, ' | ', Status], String).

seNaoTemExamesAgendados:-
    lerCsvRowList('../db/ExamesAgendados.csv', ExamesAgendados),
    ExamesAgendados = [].

pegaProximoID(ID) :-
    lerCsvRowList('../db/ExamesAgendados.csv', ExamesAgendados),
    lerCsvRowList('../db/ExamesProntos.csv', ExamesProntos),
    append(ExamesAgendados, ExamesProntos, Exames),
    (Exames = [] -> ID = 1; 
        procuraUltimoID(Exames, Ultimo),
        ID is Ultimo + 1).

procuraUltimoID([], ID) :- ID = 0.
procuraUltimoID([Exame | Restante], ID) :-
    procuraUltimoID(Restante, Numero1),
    nth0(0, Exame, Numero2),
    (Numero1 > Numero2 -> ID = Numero1;
    ID = Numero2).

printaComIndice([], _, _).
printaComIndice([Atual | Restante], IndiceProcurado, Indice) :-
    nth0(IndiceProcurado, Atual, NomeCoisa),
    write(Indice),write(' - '),writeln(NomeCoisa),
    NovoIndice is Indice + 1,
    printaComIndice(Restante, IndiceProcurado, NovoIndice).

printaComIndice([], _).
printaComIndice([Atual | Restante], Indice) :-
    write(Indice),write(' - '),writeln(Atual),
    NovoIndice is Indice + 1,
    printaComIndice(Restante, NovoIndice).

montaHorariosMedico(CrmMedico, Data, HorariosLivres) :-
    listarExamesPelaData(Data, ExamesDaData),
    separaExamesPeloMedico(CrmMedico, ExamesDaData, ExamesResultantes),
    montaHorarios(ExamesResultantes, ['08h00', '09h00', '10h00', '11h00', '12h00', '13h00', '14h00', '15h00', '16h00', '17h00'], HorariosLivres).

separaExamesPeloMedico(_, [], []).
separaExamesPeloMedico(CrmMedico, [Atual | Restante], Resultado) :-
    nth0(1, Atual, Crm),
    (Crm = CrmMedico -> (separaExamesPeloMedico(CrmMedico, Restante, ExamesResultantes),
                        append([Atual], ExamesResultantes, Resultado));
    delete([Atual | Restante], [_, Crm, _, _, _, _, _], ExamesResultantes),
    separaExamesPeloMedico(CrmMedico, ExamesResultantes, Resultado)).

montaHorarios([], Horarios, HorariosLivres) :- HorariosLivres = Horarios.
montaHorarios([Atual | Restante], Horarios, HorariosLivres) :-
    nth0(5, Atual, Hora),
    delete(Horarios, Hora, HorariosRestantes),
    montaHorarios(Restante, HorariosRestantes, HorariosLivres).

