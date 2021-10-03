getString(Variavel, Mensagem) :-
    write(Mensagem),
    read_line_to_codes(user_input, Entrada), atom_string(Entrada, Return),
    Variavel = Return.

getInt(Variavel, Mensagem) :-
    write('\n'),
    write(Mensagem),
    read_line_to_codes(user_input, Entrada), atom_string(Entrada, Return),
    (number_string(Number, Return), Number >= 0 -> Variavel = Number;
        getDouble(NewF, 'Entrada invalida! Tente digitar um numero.\n digite novamente!'), Variavel is NewF).

getDouble(Variavel, Mensagem) :-
    write('\n'),
    writeln(Mensagem),
    read_line_to_codes(user_input, Entrada), atom_string(Entrada, Return),
    (number_string(Number, Return), Number >= 0 -> Variavel = Number;
        getDouble(NewF, 'Entrada invalida! Tente digitar um número.\n Digite novamente!'), Variavel is NewF).

encripta(Atom, Encriptada) :-
    atom_codes(Atom, X),
    reverse(X, XReverse),
    atomic_list_concat(XReverse, Encriptada).

lerCsvRowList(Path,Lists):-
    csv_read_file(Path, Rows, []),
    maplist(row_to_list, Rows, Lists).

row_to_list(Row, List):-
    Row =.. [row|List].

switch(X, [Val:Goal|Cases]) :-
    ( X=Val -> call(Goal); switch(X, Cases)).