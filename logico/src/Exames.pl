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

%---------------------------- Remover Exame ---------------------------

removeExame(Nome) :-
  lerCsvRowList('../db/Exames.csv',Exames),
  getExame(Nome,ExameEncontrado),
  delete(Exames,ExameEncontrado,ExamesResultantes),
  delete_file('../db/Exames.csv'),
  open('../db/Exames.csv',append,File),
  insereExames(ExamesResultantes),
  close(File).

insereExames([]).
insereExames([Exame | Restante]) :-
  nth0(0, Exame, Nome),
  nth0(1, Exame, Preco),
  cadastraExame(Nome, Preco),
  insereExames(Restante).

%---------------------------- Editar Exame ---------------------------

editarExame(Nome,NovoNome,NovoPreco):-
  removeExame(Nome),
  cadastraExame(NovoNome,NovoPreco).

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

menuRemoverExame :-
  (seNaoTemExames -> write('Nao ha Exames cadastrados para remover!');
  (write('\n'),
  getString(Nome, 'Digite o Nome do exame que vai ser removido: '),
  getExame(Nome, Encontrado),
  proper_length(Encontrado, Tamanho),
  (Tamanho =:= 0 -> writeln('Exame nao existe no sistema!'); % Verifica se existe o código dado
      removeExame(Nome),
      write('Exame Removido!')))).

menuEditarExame :-
  (seNaoTemExames -> write('Nao ha Exames cadastrados.');
  (write('\n'),
  getString(Nome,'Digite o Nome do exame para editar: '),
  getExame(Nome,ExameEncontrado),
  proper_length(ExameEncontrado,Tamanho),
  (Tamanho =:= 0 -> writeln('Exame não cadastrado no sistema.');
      getString(NovoNome,'Qual o novo nome do exame ? '),
      getString(NovoPreco,'Qual o novo preco do exame ? '),
      editarExame(Nome,NovoNome,NovoPreco)))).

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