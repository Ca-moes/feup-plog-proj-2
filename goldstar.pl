:- use_module(library(clpfd)).

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
  labeling([], L).

magic(Vars):-
  Vars=[A1,A2,A3,A4,A5,A6,A7,A8,A9],
  domain(Vars,1,9),
  Soma is (9+1)*3//2, % Aumenta a Eficiência
  all_distinct(Vars),
  A1+A2+A3 #= Soma,
  A4+A5+A6 #= Soma,
  A7+A8+A9 #= Soma,
  A1+A4+A7 #= Soma,
  A2+A5+A8 #= Soma,
  A3+A6+A9 #= Soma,
  A1+A5+A9 #= Soma,
  A3+A5+A7 #= Soma,
  % A1 #< A2, A1 #< A3, A1 #< A4, A2 #< A4, % Eliminar simetrias
  labeling([],Vars).
   
send(Vars):-
  Vars=[S,E,N,D,M,O,R,Y],
  domain(Vars,0,9),

  all_different(Vars),
  S #\= 0, M #\= 0,
  S*1000 + E*100 + N*10 + D + M*1000 + O*100 + R*10 + E #=
  M*10000 + O*1000 + N*100 + E*10 + Y,
  
  labeling([],Vars).
   