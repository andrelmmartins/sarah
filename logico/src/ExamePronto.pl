:-use_module(library(csv)).

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
    toStringExamePronto(Exame, String),
    writeln(String),
    printaExame(Restante).

%---------------------------- Remover Exame Pronto ---------------------------

removeExamePronto(Codigo) :-
    lerCsvRowList('../db/ExamesProntos.csv', ExamesProntos),
    atom_number(Codigo, Number),
    delete(ExamesProntos, [Number, _, _], ExamesResultantes),
    delete_file('../db/ExamesProntos.csv'),
    open('../db/ExamesProntos.csv', append, File),
    insereExamesProntos(ExamesResultantes),
    close(File).

insereExamesProntos([]).
insereExamesProntos([Exame | Restante]) :-
    nth0(0, Exame, Codigo),
    nth0(1, Exame, Senha),
    nth0(2, Exame, Link),
    cadastraExamePronto(Codigo, Senha, Link),
    insereExamesProntos(Restante).

%---------------------------- Editar Exame Pronto ---------------------------

editarExamePronto(Codigo, NovoCodigo, NovaSenha, NovoLink) :-
    removeExamePronto(Codigo),
    cadastraExamePronto(NovoCodigo, NovaSenha, NovoLink).

%---------------------------- Menus ---------------------------

menuCadastrarExamePronto :-
    write('\n'),
    getString(Codigo, 'Digite o Codigo que vai referenciar o Exame Pronto: '),
    buscaExamePronto(Codigo, Encontrado),
    proper_length(Encontrado, Tamanho),
    (Tamanho > 0 -> writeln('Codigo ja existe no sistema!'); % Verifica se existe o código dado
        (getString(Senha, 'Digite a Senha que o cliente vai acessar o Resultado: '),
            encripta(Senha, Encriptada),
            getString(Link, 'Digite o Link que o cliente vai ver o Exame: '),
            (re_match('https://', Link) ->  (cadastraExamePronto(Codigo, Encriptada, Link),
                                            writeln('Exame Cadastrado com sucesso!'));
            writeln('\nLink Invalido.')))).

menuBuscarExamePronto :-
    (seNaoTemExamesProntos -> write('Nao ha Exames Prontos cadastrados para buscar!');
    (write('\n'),
    getString(Codigo, 'Digite o Codigo que vamos buscar: '),
    buscaExamePronto(Codigo, Encontrado),
    writeln(Encontrado))).

menuListarExamesProntos :-
    (seNaoTemExamesProntos -> write('Nao ha Exames Prontos cadastrados para listar!');
    (writeln('\nEsses sao os Exames Prontos cadastrados no sistema: \n'),
    listaExamesProntos)).

menuRemoverExamePronto :-
    (seNaoTemExamesProntos -> write('Nao ha Exames Prontos cadastrados para remover!');
    (write('\n'),
    getString(Codigo, 'Digite o Codigo que vai ser removido: '),
    buscaExamePronto(Codigo, Encontrado),
    proper_length(Encontrado, Tamanho),
    (Tamanho =:= 0 -> writeln('Codigo nao existe no sistema!'); % Verifica se existe o código dado
        removeExamePronto(Codigo),
        write('Exame Removido!')))).

menuEditarExamePronto :-
    (seNaoTemExamesProntos -> writeln('Nao ha Exames Prontos cadastrados para editar!');
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
            (re_match('https://', NovoLink) ->  (editarExamePronto(Codigo, NovoCodigo, Encriptada, NovoLink),
                                                writeln('\nExame Editado!'));
            writeln('\nLink Invalido.')))))))).

menuAcessarExamePronto :-
    (seNaoTemExamesProntos -> write('Nao ha Exames Prontos cadastrados para consultar!');
        (write('\n'),
        getString(Codigo, 'Digite o Codigo que consta no verso do seu exame: '),
        buscaExamePronto(Codigo, Encontrado),
        proper_length(Encontrado, Tamanho),
        (Tamanho =:= 0 -> writeln('Codigo nao existe no sistema!');
            nth0(1, Encontrado, EncriptadaCorreta),
            getString(Senha, 'Digite a Senha de acesso tambem no verso do exame: '),
            encripta(Senha, Encriptada),
            atom_number(Encriptada, Number),
            (Number \= EncriptadaCorreta -> writeln('Senha incorreta!');
                (nth0(2, Encontrado, Link),
                string_concat('\nVoce pode encontrar o link do seu exame em: ', Link, Resultado),
                writeln(Resultado)))))).

%---------------------------- Métodos Extra ---------------------------

toStringExamePronto(List, String) :-
    nth0(0, List, Codigo),
    nth0(1, List, Senha),
    nth0(2, List, Link),
    string_concat(Codigo, ' | ', X),
    string_concat(X, Senha, Y),
    string_concat(Y, ' | ', Z),
    string_concat(Z, Link, String).

seNaoTemExamesProntos:-
    lerCsvRowList('../db/ExamesProntos.csv', ExamesProntos),
    proper_length(ExamesProntos, Tamanho),
    Tamanho =:= 0.
