:- use_module(library(clpfd)).
:- use_module(library(lists)).



% star([1,2,3,4,5,6,7,8,9,10], L).
star(L):-
  % Definição das Variáveis e Domínios
  L = [A, B, C, D, E, F, G, H, I, J],
  domain(L, 0, 9),

  % Colocação das Restrições
  all_distinct(L),
  C-A #= I+F,  % 1
  A*D #= G*J,  % 2
  B+C #= D*E,  % 3
  B*F #= H*J,  % 4
  I+H #= G-E,  % 5

  % Pesquisa da solução
  labeling([], L),
  print_star(L, [1,2]).

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