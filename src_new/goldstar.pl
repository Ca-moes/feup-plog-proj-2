:- use_module(library(clpfd)).
:- use_module(library(lists)).

test:-
    gold_star([1,1,3,1,1,2,3,4,1,2]).

gold_star(Operators):-
    % Definição das Variáveis e Domínios
    length(Operators, Length),
    length(List, Length),
    Upper is Length-1,
    domain(List, 0, Upper),

    % Colocação das Restrições
    all_distinct(List),
    Last_1 is Length-1, 
    Last_2 is Length-2, 
    Last_3 is Length-3, 
    Last_4 is Length-4, 
    nth0(0, List, A),
    nth0(1, List, B),
    nth0(1, List, C),
    nth0(3, List, D),
    nth0(4, List, E),
    nth0(Last_1, List, LetterL1),
    nth0(Last_2, List, LetterL2),
    nth0(Last_3, List, LetterL3),
    nth0(Last_4, List, LetterL4),

    nth0(0, Operators, Op0i),
    nth0(1, Operators, Op1i),
    nth0(2, Operators, Op2i),
    nth0(4, Operators, Op4i),
    nth0(Last_1, Operators, OpL1i),
    nth0(Last_3, Operators, OpL3i),

    %% Restrições comuns a todos
    %%% Primeira: A (Op1) B = D (Op4) E
    apply_restriction_int(Op1i, A, B, Op4i, D, E),
    %%% Segunda: L4 (OpL3) L3 = L1 (Op0) A
    apply_restriction_int(OpL3i, LetterL4, LetterL3, Op0i, LetterL1, A),
    %%% Terceira: L2 (OpL1) L1 = B (Op2) C
    apply_restriction_int(OpL1i, LetterL2, LetterL1, Op2i, B, C),
    
    % Pesquisa da solução
    labeling([], List),

    write(Length),nl,
    write(List)
    .


apply_restriction_int(Op1Int, Var1, Var2, Op2Int, Var3, Var4):-
    numb_signal(Op1Int, Op1),
    numb_signal(Op2Int, Op2),
    apply_restriction(Op1, Var1, Var2, Op2, Var3, Var4).

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

numb_signal(1,+).
numb_signal(2,-).
numb_signal(3,*).
numb_signal(4,/).