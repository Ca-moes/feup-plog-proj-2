:- use_module(library(clpfd)).
:- use_module(library(lists)).

operator(1,+).

% star([1,2,3,4,5,6,7,8,9,10], L).
star(Operators, L):-
  % Definição das Variáveis e Domínios
  L = [A, B, C, D, E, F, G, H, I, J],
  domain(L, 0, 9),

  % Colocação das Restrições
  all_distinct(L),
  /* C-A #= I+F,  % 1
  A*D #= G*J,  % 2
  B+C #= D*E,  % 3
  B*F #= H*J,  % 4
  I+H #= G-E,  % 5 */

  Result is *(1,2),
  write(Result),

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

  % subtract(C, A, Value1),
  %-(C, A) #= Value1,
  /* *(A, D) #= Value2,
  +(B, C) #= Value3,
  D*E #= Value3,
  B*F #= Value4,
  G-E #= Value5,
  I+F #= Value1,
  G*J #= Value2,
  I+H #= Value5,
  H*J #= Value4, */

  % Pesquisa da solução
  labeling([], L),
  print_star(L, _).

apply_restriction(-, Var1, Var2, Value):-
  Var1-Var2 #= Value.
apply_restriction(+, Var1, Var2, Value):-
  Var1+Var2 #= Value.
apply_restriction(*, Var1, Var2, Value):-
  Var1*Var2 #= Value.
apply_restriction(/, Var1, Var2, Value):-
  Var1/Var2 #= Value.


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
  write('                                          '), nl, 
  format('                   ~d                      ', [A]), nl,
  write('                                          '), nl, 
  write('                -     x                   '), nl, 
  write('                                          '), nl, 
  write('                                          '), nl,
  format('~d      +      ~d    =    ~d      x       ~d  ', [B,C,D,E]), nl,
  write('                                          '), nl, 
  write('    x       =              =       -      '), nl, 
  write('                                          '), nl, 
  format('         ~d                   ~d            ', [F,G]), nl,
  write('             =          =                 '), nl, 
  write('                                          '), nl, 
  format('      +            ~d            x         ', [H]), nl,
  write('                                          '), nl, 
  write('           +              x               '), nl, 
  write('                                          '), nl, 
  format('   ~d                               ~d      ', [I,J]), nl,
  write('                                          ').





f(X,Y):-Y is X*X.
map([],_,[]).
map([C|R],Transfor,[TC|CR]):-
 aplica(Transfor, [C,TC]),
 map(R,Transfor,CR).

aplica(P,LArgs) :- G =.. [P|LArgs], G.

/*
1      1 Call: map([2,4,8],f,_1009) ? 
2      2 Call: aplica(f,[2,_2097]) ? 
3      3 Call: _3069=..[f,2,_2097] ? 
3      3 Exit: f(2,_2097)=..[f,2,_2097] ? 
4      3 Call: call(user:f(2,_2097)) ? 
5      4 Call: f(2,_2097) ? 
6      5 Call: _2097 is 2*2 ? 
6      5 Exit: 4 is 2*2 ? 
5      4 Exit: f(2,4) ? 
4      3 Exit: call(user:f(2,4)) ? 
2      2 Exit: aplica(f,[2,4]) ?
*/


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