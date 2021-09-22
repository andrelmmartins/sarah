getString(Variavel, Mensagem) :-
    write(Mensagem),
    read_line_to_codes(user_input, Entrada), atom_string(Entrada, Return),
    Variavel = Return.

encripta(Atom, Encriptada) :-
    atom_codes(Atom, X),
    reverse(X, XReverse),
    atomic_list_concat(XReverse, Encriptada).

lerCsvRowList(Path,Lists):-
    csv_read_file(Path, Rows, []),
    maplist(row_to_list, Rows, Lists).

row_to_list(Row, List):-
    Row =.. [row|List].