:- use_module(library(clpfd)).
:- use_module(library(lists)).

% Necessário mudar working directory para pasta de projeto no SicStus 
% prolog:set_current_directory('C:/Data/Andre/Work/MIEIC_A3S1/PLOG/feup-plog-proj-2').
/*
save(operators)
save(print_all_comb)
save(save_1_solution)
*/
save(Predicate):-
  open('test.txt', write, S1),
  current_output(Console),
  set_output(S1),
  statistics(runtime, [T0|_]),
  ((Predicate, fail) ; true),
  statistics(runtime, [T1|_]),
  T is T1 - T0,
  close(S1),
  set_output(Console),
  format('~w took ~3d sec.~n', [Predicate, T]).


% Prints to the console all of the stars that are possible to be made
print_all_comb:-
  star(L), fail.

print_1_solution:-
  star(L, Ops), Ops == [4,4,4,4,4,4,4,4,4,4].


/*
Pelo que o DCS disse é para criar uma lista de operadores 
aleatória e pôr dentro do star/1 para ele resolver, se não tiver resolução 
cria outra e resolve até uma lista de ops tiver solução

Isto para confirmar que o método que soluciona funciona
*/
/* generate_operators(L):-
 */

test:-
  % spy operators,
  operators(Ops),
  star(Ops, L), fail,
  write(L).

/*
Encontra uma das 1.04m de possiveis combinações de operadores
*/
operators(Ops):-
  % Definição das Variáveis e Domínios
  length(Ops, 10),
  domain(Ops, 1, 4),

  % Colocação das Restrições
  element(1, Ops, Op1i),
  bigger(Op1i, Ops),

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
  print_option(L, Ops), !.

apply_restriction(Op1i, Var1, Var2, Op2i, Var3, Var4):-
  numb_signal(Op1i, Op1),
  numb_signal(Op2i, Op2),
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

bigger(Op1, []).
bigger(Op1, [Op | Rest]) :-
    Op1 #>= Op,
    bigger(Op1, Rest).

numb_signal(1,+).
numb_signal(2,-).
numb_signal(3,*).
numb_signal(4,/).

print_option(NumberList, OperatorList):-
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
  format('[~w,~w,~w,~w,~w,~w,~w,~w,~w,~w]\n', [Op0, Op1, Op2, Op3, Op4, Op5, Op6, Op7, Op8, Op9]),
  write(NumberList), nl.
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