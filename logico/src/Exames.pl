:-use_module(library(csv)).
:-include('Util.pl').

%---------------------------- Cadastrar um Exame -----------------------------------

cadastraExame(Nome, Valor) :-
  open('../db/Exames.csv', append, File),
  writeln(File, (Nome, Valor)),                 
  close(File).

%---------------------------- Buscar um Exame  -------------------------------------

getExame(Nome, Encontrado) :-
  (exists_file('../db/Exames.csv') -> (lerCsvRowList('../db/Exames.csv', ExamesList),
  getExameEmLista(Nome, ExamesList, Encontrado));
  Encontrado = []).

getExameEmLista(_, [], []).
getExameEmLista(Nome, [Atual | Restante], Encontrada) :-
    nth0(0, Atual, X),
    (atom_string(X, Nome) -> Encontrada = Atual;
    getExameEmLista(Nome, Restante, Encontrada)).

%---------------------------- Listar Exames ---------------------------

listaExames :-
  lerCsvRowList('../db/Exames.csv', Exames),
  printaExames(Exames).

printaExames([]).
printaExames([Exame | Restante]) :- 
  toString(Exame, String),
  writeln(String),
  printaExames(Restante).

%---------------------------- Menus -----------------------------------------------

menuCadastrarExame :-
  write('\n'),
  getString(Nome, 'Digite o Nome do Exame: '),
  getExame(Nome, Encontrado),
  proper_length(Encontrado, Tamanho),
  (Tamanho > 0 -> writeln('Exame ja existe no sistema!'); % Verifica se existe o exame passado para cadastro
      (getString(Preco, 'Informe o preco do exame: '),
        cadastraExame(Nome, Preco),
        writeln('Exame cadastrado com sucesso!'))).

menuBuscarExame :-
  (seNaoTemExames -> write('Nao ha Exames cadastrados para buscar!');
  (write('\n'),
  getString(Nome, 'Digite o nome do exame que vamos buscar: '),
  getExame(Nome, Encontrado),
  writeln(Encontrado))).

menuListarExames :-
  (seNaoTemExames -> write('Nao ha Exames cadastrados!');
  (writeln('\nEsses sao os Exames cadastrados no sistema: \n'),
  listaExames)).

%---------------------------- Métodos Extra ---------------------------------------

toString(List, String) :-
  nth0(0, List, Nome),
  nth0(1, List, Preco),
  string_concat(Nome, ' | ', X),
  string_concat(X, 'R$', Y),
  string_concat(Y, Preco, String).

seNaoTemExames:-
  lerCsvRowList('../db/Exames.csv', Exames),
  proper_length(Exames, Tamanho),
  Tamanho =:= 0.