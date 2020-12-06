:- use_module(library(clpfd)).
:- use_module(library(lists)).

% Prints to the console all of the stars that are possible to be made
print_all_comb:-
  star(L), fail.

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

star(L):-
  % Definição das Variáveis e Domínios
  L = [A, B, C, D, E, F, G, H, I, J],
  domain(L, 0, 9),
  Ops = [Op1i, Op2i, Op3i, Op4i, Op5i, Op6i, Op7i, Op8i, Op9i, Op10i],
  domain(Ops, 1, 4),

  % Colocação das Restrições
  all_distinct(L),

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

  % Pesquisa da solução
  labeling([], L),
  print_option(L, Ops).

/* apply_restriction(+, Op2, Var1, Var2, Var3, Var4):-
  Var1+Var2 #= Value,
  apply_restriction(Op2, Var3, Var3, Value). */

apply_restriction(+, Var1, Var2, Value):-
  Var1+Var2 #= Value.
apply_restriction(-, Var1, Var2, Value):-
  Var1-Var2 #= Value.
apply_restriction(*, Var1, Var2, Value):-
  Var1*Var2 #= Value.
apply_restriction(/, Var1, Var2, Value):-
  Var1/Var2 #= Value.
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
  write(NumberList), nl, nl.
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