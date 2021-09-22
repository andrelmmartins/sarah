:-use_module(library(csv)).
:-include('Util.pl').

%---------------------------- Cadastrar um Exame Pronto -----------------------------------

cadastraExamePronto(Codigo, Senha, Link) :-
    open('../db/ExamesProntos.csv', append, File),
    writeln(File, (Codigo, Senha, Link)),                 
    close(File).

%---------------------------- Buscar um Exame Pronto ----------------------------

buscaExamePronto(Codigo, Encontrado) :-
    (exists_file('../db/ExamesProntos.csv') -> (lerCsvRowList('../db/ExamesProntos.csv', ExamesProntos),
    buscaExameEmLista(Codigo, ExamesProntos, Encontrado));
    Encontrado = []).

buscaExameEmLista(_, [], []).
buscaExameEmLista(Codigo, [Atual | Restante], Encontrado) :-
    atom_number(Codigo, Number),
    (nth0(0, Atual, Number) -> Encontrado = Atual;
    buscaExameEmLista(Codigo, Restante, Encontrado)).
    
%---------------------------- Listar Exames Prontos ---------------------------

listaExamesProntos :-
    lerCsvRowList('../db/ExamesProntos.csv', ExamesProntos),
    printaExame(ExamesProntos).

printaExame([]).
printaExame([Exame | Restante]) :- 
    toString(Exame, String),
    writeln(String),
    printaExame(Restante).

%---------------------------- Remover Exame Pronto ---------------------------

removeExamePronto(Codigo) :-
    lerCsvRowList('../db/ExamesProntos.csv', ExamesProntos),
    atom_number(Codigo, Number),
    delete(ExamesProntos, [Number, _, _], ExamesResultantes),
    delete_file('../db/ExamesProntos.csv'),
    insereExames(ExamesResultantes).

insereExames([]).
insereExames([Exame | Restante]) :-
    nth0(0, Exame, Codigo),
    nth0(1, Exame, Senha),
    nth0(2, Exame, Link),
    cadastraExamePronto(Codigo, Senha, Link),
    insereExames(Restante).

%---------------------------- Editar Exame Pronto ---------------------------

editarExamePronto(Codigo, NovoCodigo, NovaSenha, NovoLink) :-
    removeExamePronto(Codigo),
    cadastraExamePronto(NovoCodigo, NovaSenha, NovoLink).

%---------------------------- Menus ---------------------------

menuCadastrarExame :-
    write('\n'),
    getString(Codigo, 'Digite o Codigo que vai referenciar o Exame Pronto: '),
    buscaExamePronto(Codigo, Encontrado),
    proper_length(Encontrado, Tamanho),
    (Tamanho > 0 -> writeln('Codigo ja existe no sistema!'); % Verifica se existe o código dado
        (getString(Senha, 'Digite a Senha que o cliente vai acessar o Resultado: '),
            encripta(Senha, Encriptada),
            getString(Link, 'Digite o Link que o cliente vai ver o Exame: '),
            cadastraExamePronto(Codigo, Encriptada, Link),
            write('Exame Cadastrado com sucesso!'))).

menuBuscarExame :-
    (seNaoTemExames -> write('Nao ha Exames Prontos cadastrados para buscar!');
    (write('\n'),
    getString(Codigo, 'Digite o Codigo que vamos buscar: '),
    buscaExamePronto(Codigo, Encontrado),
    writeln(Encontrado))).

menuListarExames :-
    (seNaoTemExames -> write('Nao ha Exames Prontos cadastrados para listar!');
    (writeln('\nEsses sao os Exames Prontos cadastrados no sistema: \n'),
    listaExamesProntos)).

menuRemoverExame :-
    (seNaoTemExames -> write('Nao ha Exames Prontos cadastrados para remover!');
    (write('\n'),
    getString(Codigo, 'Digite o Codigo que vai ser removido: '),
    buscaExamePronto(Codigo, Encontrado),
    proper_length(Encontrado, Tamanho),
    (Tamanho =:= 0 -> writeln('Codigo nao existe no sistema!'); % Verifica se existe o código dado
        removeExamePronto(Codigo),
        write('Exame Removido!')))).

menuEditarExame :-
    (seNaoTemExames -> write('Nao ha Exames Prontos cadastrados para editar!');
    (write('\n'),
    getString(Codigo, 'Digite o Codigo que vai ser editado: '),
    buscaExamePronto(Codigo, Encontrado),
    proper_length(Encontrado, Tamanho),
    (Tamanho =:= 0 -> writeln('Codigo nao existe no sistema!'); % Verifica se existe o código dado
        (getString(NovoCodigo, 'Digite o Novo Codigo: '),
        buscaExamePronto(NovoCodigo, Encontrado2),
        proper_length(Encontrado2, Tamanho2),
        ((Tamanho2 > 0, Codigo \= NovoCodigo) -> writeln('Codigo ja existe no sistema!'); % Verifica se o novo código já não existe
            (getString(NovaSenha, 'Digite a Nova Senha que o cliente vai acessar o Resultado: '), % Pega a nova senha
            encripta(NovaSenha, Encriptada),
            getString(NovoLink, 'Digite o Novo Link onde o cliente vai ver o Exame: '), % Pega o novo link
            editarExamePronto(Codigo, NovoCodigo, Encriptada, NovoLink),
            write('Exame Editado!'))))))).

%---------------------------- Métodos Extra ---------------------------

toString(List, String) :-
    nth0(0, List, Codigo),
    nth0(1, List, Senha),
    nth0(2, List, Link),
    string_concat(Codigo, ' | ', X),
    string_concat(X, Senha, Y),
    string_concat(Y, ' | ', Z),
    string_concat(Z, Link, String).

seNaoTemExames:-
    lerCsvRowList('../db/ExamesProntos.csv', ExamesProntos),
    proper_length(ExamesProntos, Tamanho),
    Tamanho =:= 0.

