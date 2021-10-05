:-use_module(library(csv)).

cadastrarMedico(Crm,Nome,Especialidade) :-
    open('../db/Medicos.csv', append, File),
    writeln(File, (Crm,Nome,Especialidade)),                 
    close(File).

buscaMedico(Crm, Encontrado) :-
    (exists_file('../db/Medicos.csv') -> (lerCsvRowList('../db/Medicos.csv', Medicos),
    buscaMedicoEmLista(Crm, Medicos, Encontrado));
    Encontrado = []).

buscaMedicoEmLista(_, [], []).
buscaMedicoEmLista(Crm, [Atual | Restante], Encontrado) :-
    atom_number(Crm, Number),
    (nth0(0, Atual, Number) -> Encontrado = Atual;
    buscaMedicoEmLista(Crm, Restante, Encontrado)).

listaMedicos :-
    lerCsvRowList('../db/Medicos.csv', Medicos),
    printaMedicos(Medicos).

printaMedicos([]).
printaMedicos([Medico | Restante]) :- 
    toStringMedico(Medico, String),
    writeln(String),
    printaMedicos(Restante).

toStringMedico(List, String) :-
    nth0(0,List,Crm),
    nth0(1,List,Nome),
    nth0(2,List,Especialidade),
    atomic_list_concat([Crm, ' | ', Nome, ' | ', Especialidade],String).

seNaoTemMedicos :-
    lerCsvRowList('../db/Medicos.csv', Medicos),
    proper_length(Medicos, Tamanho),
    Tamanho =:= 0.

removerMedico(Crm) :-
    lerCsvRowList('../db/Medicos.csv',Medicos),
    buscaMedico(Crm,Encontrada),
    delete(Medicos,Encontrada,MedicosResultantes),
    delete_file('../db/Medicos.csv'),
    open('../db/Medicos.csv',append,File),
    insereMedicos(MedicosResultantes),
    close(File).

insereMedicos([]).
insereMedicos([Medicos | Restante]) :-
    nth0(0,Medicos, Crm),
    nth0(1,Medicos, Nome),
    nth0(2,Medicos, Especialidade),
    cadastrarMedico(Crm,Nome,Especialidade),
    insereMedicos(Restante).

editarMedico(Crm,NovoNome,NovaEspecialidade):-
    removerMedico(Crm),
    cadastrarMedico(Crm,NovoNome,NovaEspecialidade).

menuCadastrarMedico :-
    write('\n'),
    getString(Crm, 'Crm do medico a ser cadastrado: '),
    buscaMedico(Crm, Encontrado),
    proper_length(Encontrado, Tamanho),
    (Tamanho > 0 -> writeln('Ja existe umm medico com esse crm cadastrado!'); 
        (getString(Nome, 'Nome do medico: '),
        getString(Especialidade, 'Especialidade do medico: '),
        cadastrarMedico(Crm,Nome,Especialidade),
        writeln('Medico cadastrado!'))).

menuListarMedicos :-
    (seNaoTemMedicos -> write('Nao tem nenhum medico cadastrado.');
    (write('\nEsses são os medicos cadastrados: \n \n'),
    listaMedicos)).

menuEditarMedico :-
    (seNaoTemMedicos -> write('Nao tem nenhum medico cadastrado.');
    (write('\n'),
    getString(Crm,'Qual o CRM do medico a ser editado: '),
    buscaMedico(Crm,Encontrado),
    proper_length(Encontrado,Tamanho),
    (Tamanho =:= 0 -> writeln('Medico não encontrado no sistema.');
        getString(NovoNome,'Qual o novo nome do medico: '),
        getString(NovaEspecialidade,'Qual a nova especialidade do medico: '),
        editarMedico(Crm,NovoNome,NovaEspecialidade)))).

menuRemoverMedico :-
    (seNaoTemMedicos -> write('Nao ha medicos cadastradss para remover!');
    (write('\n'),
    getString(Crm, 'Qual o crm do medico que vai ser removido: '),
    buscaMedico(Crm, Encontrado),
    proper_length(Encontrado, Tamanho),
    (Tamanho =:= 0 -> writeln('Medico nao existe no sistema!');
        removerMedico(Crm),
        writeln('Medico removido!')))).