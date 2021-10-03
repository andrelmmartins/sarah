:-use_module(library(csv)).

cadastrarConvenio(Cnpj,Nome,Desconto) :-
    open('../db/Convenios.csv', append, File),
    writeln(File, (Cnpj,Nome,Desconto)),                 
    close(File).

buscaConvenio(Cnpj, Encontrado) :-
    (exists_file('../db/Convenios.csv') -> (lerCsvRowList('../db/Convenios.csv', Convenios),
    buscaConvenioEmLista(Cnpj, Convenios, Encontrado));
    Encontrado = []).

buscaConvenioEmLista(_, [], []).
buscaConvenioEmLista(Cnpj, [Atual | Restante], Encontrado) :-
    atom_number(Cnpj, Number),
    (nth0(0, Atual, Number) -> Encontrado = Atual;
    buscaConvenioEmLista(Cnpj, Restante, Encontrado)).

menuCadastrarConvenio :-
    write('\n'),
    getString(Cnpj, 'CNPJ do convenio a ser cadastrado: '),
    buscaConvenio(Cnpj, Encontrada),
    proper_length(Encontrada, Tamanho),
    (Tamanho > 0 -> writeln('Ja existe uma convenio com esse cnpj cadastrado!'); 
        (getString(Nome, 'Nome do convenio: '),
        getInt(Desconto, 'Desconto concedido em %: '),
        cadastrarConvenio(Cnpj,Nome,Desconto),
        writeln('Convenio cadastrado!'))).


listaConvenios :-
    lerCsvRowList('../db/Convenios.csv', Convenios),
    printaConvenios(Convenios).

printaConvenios([]).
printaConvenios([Convenios | Restante]) :- 
    toStringConvenio(Convenios, String),
    writeln(String),
    printaConvenios(Restante).

toStringConvenio(List, String) :-
    nth0(0,List,Cnpj),
    nth0(1,List,Nome),
    nth0(2,List,Desconto),
    atomic_list_concat([Cnpj, ' | ', Nome, ' | ', Desconto],String).

seNaoTemConvenios :-
    lerCsvRowList('../db/Convenios.csv', Convenios),
    proper_length(Convenios, Tamanho),
    Tamanho =:= 0.

menuListarConvenios :-
    (seNaoTemConvenios -> write('Nao tem nenhum convenio cadastrado.');
    (write('\nEsses são os convenios cadastrados: \n \n'),
    listaConvenios)).

removerConvenio(Cnpj) :-
    lerCsvRowList('../db/Convenios.csv',Convenios),
    buscaConvenio(Cnpj,Encontrada),
    delete(Convenios,Encontrada,ConveniosResultantes),
    delete_file('../db/Convenios.csv'),
    open('../db/Convenios.csv',append,File),
    insereConvenios(ConveniosResultantes),
    close(File).

insereConvenios([]).
insereConvenios([Convenios | Restante]) :-
    nth0(0,Convenios, Cnpj),
    nth0(1,Convenios, Nome),
    nth0(2,Convenios, Desconto),
    cadastrarConvenio(Cnpj,Nome,Desconto),
    insereConvenios(Restante).

menuRemoverConvenio :-
    (seNaoTemConvenios -> write('Nao ha convenios cadastradss para remover!');
    (write('\n'),
    getString(Cnpj, 'Qual a cnpj da convenio que vai ser removido: '),
    buscaConvenio(Cnpj, Encontrada),
    proper_length(Encontrada, Tamanho),
    (Tamanho =:= 0 -> writeln('Convenio nao existe no sistema!');
        removerConvenio(Cnpj),
        writeln('Convenio removido!')))).

editarConvenio(Cnpj,NovoNome,NovoDesconto):-
    removerConvenio(Cnpj),
    cadastrarConvenio(Cnpj,NovoNome,NovoDesconto).

menuEditarConvenio :-
    (seNaoTemConvenios -> write('Nao tem nenhum convenio cadastrado.');
    (write('\n'),
    getString(Cnpj,'Qual o CNPJ do convenio a ser editado: '),
    buscaConvenio(Cnpj,Encontrada),
    proper_length(Encontrada,Tamanho),
    (Tamanho =:= 0 -> writeln('Convenio não cadastrado no sistema.');
        getString(NovoNome,'Qual o novo nome do convenio: '),
        getInt(NovoDesconto,'Qual o novo desconto do convenio em %: '),
        editarConvenio(Cnpj,NovoNome,NovoDesconto)))).

