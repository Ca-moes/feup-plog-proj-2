:- use_module(library(clpfd)).
:- use_module(library(lists)).

% Prints to the console all of the stars that are possible to be made
print_all_comb:-
  star(_, _), fail.

save_all_comb:-
  open('test.txt', write, S1),
  set_output(S1),
  print_all_comb.


% Necessário mudar working directory para pasta de projeto no SicStus 
write_to_file:-
  open('test.txt', write, S1),
  set_output(S1),
  write('test 1234\n'),
  flush_output(S1),
  close(S1).

star(Operators, L):-
  % Definição das Variáveis e Domínios
  L = [A, B, C, D, E, F, G, H, I, J],
  domain(L, 0, 9),

  % Colocação das Restrições
  all_distinct(L),

  nth0(0, Operators, Op1),
  apply_restriction(Op1, C, A, Value1),
  nth0(1, Operators, Op2),
  apply_restriction(Op2, A, D, Value2),  
  nth0(2, Operators, Op3),
  apply_restriction(Op3, B, C, Value3), 
  nth0(3, Operators, Op4),
  apply_restriction(Op4, D, E, Value3), 
  nth0(4, Operators, Op5),
  apply_restriction(Op5, B, F, Value4), 
  nth0(5, Operators, Op6),
  apply_restriction(Op6, G, E, Value5), 
  nth0(6, Operators, Op7),
  apply_restriction(Op7, I, F, Value1), 
  nth0(7, Operators, Op8),
  apply_restriction(Op8, G, J, Value2), 
  nth0(8, Operators, Op9),
  apply_restriction(Op9, I, H, Value5), 
  nth0(9, Operators, Op10),
  apply_restriction(Op10, H, J, Value4), 

  % Pesquisa da solução
  labeling([], L),
  print_option(L, Operators).

apply_restriction(+, Var1, Var2, Value):-
  Var1+Var2 #= Value.
apply_restriction(-, Var1, Var2, Value):-
  Var1-Var2 #= Value.
apply_restriction(*, Var1, Var2, Value):-
  Var1*Var2 #= Value.
apply_restriction(/, Var1, Var2, Value):-
  Var1/Var2 #= Value.

print_option(NumberList, OperatorList):-
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

*/