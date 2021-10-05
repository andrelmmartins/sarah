:-use_module(library(csv)).

cadastrarAvaliacao(Avaliacao) :-
    open('../db/Avaliacoes.csv', append, File),
    writeln(File, (Avaliacao)),                 
    close(File).

listaAvaliacoes :-
    lerCsvRowList('../db/Avaliacoes.csv', Avaliacao),
    printaAvaliacoes(Avaliacao).

printaAvaliacoes([]).
printaAvaliacoes([Avaliacao | Restante]) :- 
    writeln(Avaliacao),
    printaAvaliacoes(Restante).

seNaoTemAvaliacoes :-
    lerCsvRowList('../db/Avaliacoes.csv', Avaliacoes),
    proper_length(Avaliacoes, Tamanho),
    Tamanho =:= 0.


menuCadastrarAvaliacao :-
    write('\n'),
    getString(Avaliacao, 'Avalie nossa clinica: '),
    cadastrarAvaliacao(Avaliacao),
    writeln('Obrigado pela avaliacao!').

menuListarAvaliacoes :-
    (seNaoTemAvaliacoes -> write('Nao tem nenhuma avaliacao cadastrada.');
    (write('\nEsses sao as avaliacoes cadastrados: \n \n'),
    listaAvaliacoes)).