:- use_module(library(clpfd)).
:- use_module(library(lists)).

/*
Necessário mudar working directory para pasta de projeto no SicStus 
prolog:set_current_directory('C:/Data/Andre/Work/MIEIC_A3S1/PLOG/feup-plog-proj-2'), consult('C:/Data/Andre/Work/MIEIC_A3S1/PLOG/feup-plog-proj-2/goldstar.pl').
*/

save_all:-
  true.

/*
save(operators)
save(print_all_comb)
save(save_1_solution)
*/
save(Predicate):-
  get_file_name(Predicate, FileName),
  open(FileName, write, S1),
  current_output(Console),
  set_output(S1),
  statistics(runtime, [T0|_]),
  (Predicate ; true),
  statistics(runtime, [T1|_]),
  T is T1 - T0,
  format('~w took ~3d sec.~n', [Predicate, T]),
  close(S1),
  set_output(Console),
  format('~w took ~3d sec.~n', [Predicate, T]).

get_file_name(Predicate, FileName):-
  Predicate =.. L,
  nth0(0, L, Name),
  atom_concat(Name, '.txt', FileName).

write_to_file:-
  open('test.txt', write, S1),
  set_output(S1),
  write('test 1234\n'),
  close(S1).

% Usado sem cut em star, encontra todas as soluções para todas as disposições
% calcula operadores dentro de star
print_all_comb:-
  star(Ops,_), fail.

/*
Sem Cut em Star:
  - Aplica restrições ás combinações de operadores e imprime todas as soluções 
  para todas as disposições
Com Cut em Star:
  - Arranja uma solução para cada disposição com restrições
*/
print_restricted:-
  operators_rest(Opsi),
  opsi_to_opss(Opsi, Ops),
  star(Ops, _), fail.

/*
Sem Cut em Star:
  - Arranja todas as soluções para todas as disposições sem restrições
Com Cut em Star:
  - Arranja uma solução para cada disposição sem restrições, 1.04m de resultados
*/
print_unrestricted:-
  operators(Opsi),
  opsi_to_opss(Opsi, Ops),
  star(Ops, L), fail.

opsi_to_opss([],[]).
opsi_to_opss([H|T], [Sig|Temp]):-
  numb_signal(H, Sig),
  opsi_to_opss(T, Temp).

/*
Encontra uma das 1.04m de possiveis combinações de operadores
*/
operators_rest(Ops):-
  % Definição das Variáveis e Domínios
  length(Ops, 10),
  domain(Ops, 1, 4),

  % Colocação das Restrições
  element(1, Ops, Op1i),
  bigger(Op1i, Ops),

  % Pesquisa da solução
  labeling([], Ops).

operators(Ops):-
  % Definição das Variáveis e Domínios
  length(Ops, 10),
  domain(Ops, 1, 4),

  % Sem Colocação das Restrições

  % Pesquisa da solução
  labeling([], Ops).

star(Ops, L):-
  % Definição das Variáveis e Domínios
  L = [A, B, C, D, E, F, G, H, I, J],
  domain(L, 0, 9),

  % Colocação das Restrições
  all_distinct(L),

  nth0(0, Ops, Op0i),
  nth0(1, Ops, Op1i),
  nth0(2, Ops, Op2i),
  nth0(3, Ops, Op3i),
  nth0(4, Ops, Op4i),
  nth0(5, Ops, Op5i),
  nth0(6, Ops, Op6i),
  nth0(7, Ops, Op7i),
  nth0(8, Ops, Op8i),
  nth0(9, Ops, Op9i),

  apply_restriction(Op0i, C, A, Op7i, I, F),
  apply_restriction(Op1i, A, D, Op4i, G, J),
  apply_restriction(Op9i, B, C, Op2i, D, E),
  apply_restriction(Op8i, B, F, Op5i, H, J),
  apply_restriction(Op3i, G, E, Op6i, I, H),
  
  % Pesquisa da solução
  labeling([], L),
  print_option_opss(L, Ops).

apply_restriction(Op1, Var1, Var2, Op2, Var3, Var4):-
  apply_restriction(Op1, Var1, Var2, Value),
  apply_restriction(Op2, Var3, Var4, Value).
apply_restriction(+, Var1, Var2, Value):-
  Var1+Var2 #= Value.
apply_restriction(-, Var1, Var2, Value):-
  Var1-Var2 #= Value.
apply_restriction(*, Var1, Var2, Value):-
  Var1*Var2 #= Value.
apply_restriction(/, Var1, Var2, Value):-
  Var1/Var2 #= Value.

bigger(_, []).
bigger(Op1, [Op | Rest]) :-
    Op1 #>= Op,
    bigger(Op1, Rest).

numb_signal(1,+).
numb_signal(2,-).
numb_signal(3,*).
numb_signal(4,/).

print_option_opss(NumberList, OperatorList):-
  nth0(0, OperatorList, Op0),
  nth0(1, OperatorList, Op1),
  nth0(2, OperatorList, Op2),
  nth0(3, OperatorList, Op3),
  nth0(4, OperatorList, Op4),
  nth0(5, OperatorList, Op5),
  nth0(6, OperatorList, Op6),
  nth0(7, OperatorList, Op7),
  nth0(8, OperatorList, Op8),
  nth0(9, OperatorList, Op9),
  format('[~w,~w,~w,~w,~w,~w,~w,~w,~w,~w]', [Op0, Op1, Op2, Op3, Op4, Op5, Op6, Op7, Op8, Op9]),
  write(NumberList), nl.
print_option_opsi(NumberList, OperatorList):-
  nth0(0, OperatorList, Op0i), numb_signal(Op0i, Op0),
  nth0(1, OperatorList, Op1i), numb_signal(Op1i, Op1),
  nth0(2, OperatorList, Op2i), numb_signal(Op2i, Op2),
  nth0(3, OperatorList, Op3i), numb_signal(Op3i, Op3),
  nth0(4, OperatorList, Op4i), numb_signal(Op4i, Op4),
  nth0(5, OperatorList, Op5i), numb_signal(Op5i, Op5),
  nth0(6, OperatorList, Op6i), numb_signal(Op6i, Op6),
  nth0(7, OperatorList, Op7i), numb_signal(Op7i, Op7),
  nth0(8, OperatorList, Op8i), numb_signal(Op8i, Op8),
  nth0(9, OperatorList, Op9i), numb_signal(Op9i, Op9),
  format('[~w,~w,~w,~w,~w,~w,~w,~w,~w,~w]', [Op0, Op1, Op2, Op3, Op4, Op5, Op6, Op7, Op8, Op9]),
  write(NumberList), nl.

%% DESATUALIZADO, operadores em lugares diferentes
print_star(NumberList, OperatorList):-
  nth0(0, NumberList, A),
  nth0(1, NumberList, B),
  nth0(2, NumberList, C),
  nth0(3, NumberList, D),
  nth0(4, NumberList, E),
  nth0(5, NumberList, F),
  nth0(6, NumberList, G),
  nth0(7, NumberList, H),
  nth0(8, NumberList, I),
  nth0(9, NumberList, J),
  nth0(0, OperatorList, Op0),
  nth0(1, OperatorList, Op1),
  nth0(2, OperatorList, Op2),
  nth0(3, OperatorList, Op3),
  nth0(4, OperatorList, Op4),
  nth0(5, OperatorList, Op5),
  nth0(6, OperatorList, Op6),
  nth0(7, OperatorList, Op7),
  nth0(8, OperatorList, Op8),
  nth0(9, OperatorList, Op9),
  write('                                                 '), nl, 
  format('                   ~d                           ', [A]), nl,
  write('                                                 '), nl,
  format('                ~w     ~w                       ', [Op0, Op1]), nl,
  write('                                                 '), nl, 
  write('                                                 '), nl,
  format('~d      ~w      ~d    =    ~d      ~w       ~d  ', [B,Op2,C,D,Op3,E]), nl,
  write('                                                 '), nl, 
  format('    ~w       =              =       ~w          ', [Op4, Op5]), nl,
  write('                                                 '), nl, 
  format('         ~d                   ~d                ', [F,G]), nl,
  write('             =          =                        '), nl, 
  write('                                                 '), nl, 
  format('      ~w            ~d            ~w            ', [Op6,H,Op7]), nl,
  write('                                                 '), nl, 
  format('           ~w              ~w                   ',[Op8, Op9]), nl,
  write('                                                 '), nl, 
  format('   ~d                               ~d          ', [I,J]), nl,
  write('                                                 ').

/*
                                          
                   6                      
                                          
                -     x                   
                                          
                                          
8      +      7    =    3      x       5  
                                          
    x       =              =       -      
                                          
         1                   9            
             =          =                 
                                          
      +            4            x         
                                          
           +              x               
                                          
   0                               2      
                                          

*/

/*

10 posições possiveis para sinais
4 sinais : + - * /
10^4 = 1.048.576 Combinações possiveis de estrelas.


numb_signal(Op1i, Op1),
  apply_restriction(Op1, C, A, Value1),
  numb_signal(Op2i, Op2),
  apply_restriction(Op2, A, D, Value2),  
  numb_signal(Op3i, Op3),
  apply_restriction(Op3, B, C, Value3), 
  numb_signal(Op4i, Op4),
  apply_restriction(Op4, D, E, Value3), 
  numb_signal(Op5i, Op5),
  apply_restriction(Op5, B, F, Value4), 
  numb_signal(Op6i, Op6),
  apply_restriction(Op6, G, E, Value5), 
  numb_signal(Op7i, Op7),
  apply_restriction(Op7, I, F, Value1), 
  numb_signal(Op8i, Op8),
  apply_restriction(Op8, G, J, Value2), 
  numb_signal(Op9i, Op9),
  apply_restriction(Op9, I, H, Value5), 
  numb_signal(Op10i, Op10),
  apply_restriction(Op10, H, J, Value4), 

*/

write_to_file:-
  open('test.txt', write, S1),
  set_output(S1),
  write('test 1234\n'),
  flush_output(S1),
  close(S1).