:- use_module(library(clpfd)).
:- use_module(library(lists)).

test:-
    operators_restricted(OpsInt),
    opsi_to_opss(OpsInt, Ops),
    gold_star(Ops, Result),
    fail.

operators_restrited(Ops):-
    % Definição das Variáveis e Domínios
    length(Ops, 14),
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

bigger(_, []).
bigger(Op1, [Op | Rest]) :-
    Op1 #>= Op,
    bigger(Op1, Rest).

gold_star(Operators, Result):-
    % Definição das Variáveis e Domínios
    length(Operators, Length),
    length(Result, Length),
    Upper is Length-1,
    domain(Result, 0, Upper),

    % Colocação das Restrições
    all_distinct(Result),
    first_restrictions(Operators, Result),
    remaining_restrictions(Operators, Result),

    % Pesquisa da solução
    labeling([], Result),
    print_result(Operators, Result)
    .

first_restrictions(Operators, Operands):-
    length(Operators, Length),
    Last_1 is Length-1, 
    Last_2 is Length-2, 
    Last_3 is Length-3, 
    Last_4 is Length-4, 
    nth0(0, Operands, A),
    nth0(1, Operands, B),
    nth0(2, Operands, C),
    nth0(3, Operands, D),
    nth0(4, Operands, E),
    nth0(Last_1, Operands, LetterL1),
    nth0(Last_2, Operands, LetterL2),
    nth0(Last_3, Operands, LetterL3),
    nth0(Last_4, Operands, LetterL4),
    nth0(0, Operators, Op0i),
    nth0(1, Operators, Op1i),
    nth0(2, Operators, Op2i),
    nth0(4, Operators, Op4i),
    nth0(Last_1, Operators, OpL1i),
    nth0(Last_3, Operators, OpL3i),
    %% Restrições comuns a todos
    %%% Primeira: A (Op1) B = D (Op4) E
    apply_restriction(Op1i, A, B, Op4i, D, E),
    %%% Segunda: L4 (OpL3) L3 = L1 (Op0) A
    apply_restriction(OpL3i, LetterL4, LetterL3, Op0i, LetterL1, A),
    %%% Terceira: L2 (OpL1) L1 = B (Op2) C
    apply_restriction(OpL1i, LetterL2, LetterL1, Op2i, B, C).

remaining_restrictions(Operators, Operands):-
    [_,_|ListRest] = Operands,
    apply_remaining_restrictions(Operators, ListRest, 6, 3).

% Para prevenir adicionar restrições com 3 pontas ou menos
apply_remaining_restrictions(Operators, Operands, Index1, Index2):-
    length(Operators, Len),
    Len =< 6.
% No caso de adicionar a última restrição, não chama recursivamente. Verifica se o indice 1 dos operadores é igual ao penultimo indice
apply_remaining_restrictions(Operators, Operands, Index1, Index2):-
    length(Operators, OpsL),
    Test is OpsL - 2,
    Index1 == Test,
    apply_rem_rest_helper(Operators, Operands, Index1, Index2).
% aplica a restrição, limita a lista dos operandos, busca os próximos indices e continua a recursividade
apply_remaining_restrictions(Operators, Operands, Index1, Index2):-
    apply_rem_rest_helper(Operators, Operands, Index1, Index2),    
    [_,_|OperandsRest] = Operands,
    NewIndex1 is Index1+2,
    NewIndex2 is Index2+2,
    apply_remaining_restrictions(Operators, OperandsRest, NewIndex1, NewIndex2).

% predicado para buscar os valores e aplicar a restrição intermédia
apply_rem_rest_helper(Operators, Operands, Index1, Index2):-
    nth0(0, Operands, D),
    nth0(1, Operands, C),
    nth0(3, Operands, B),
    nth0(4, Operands, A),
    nth0(Index1, Operators, Op1),
    nth0(Index2, Operators, Op2),
    apply_restriction(Op1, A, B, Op2, C, D).

% predicado para aplicar a restrição da equação
apply_restriction(Op1, Var1, Var2, Op2, Var3, Var4):-
    apply_restriction(Op1, Var1, Var2, Value),
    apply_restriction(Op2, Var3, Var4, Value).
apply_restriction(+, Var1, Var2, Value):-
    Var1+Var2 #= Value.
apply_restriction(-, Var1, Var2, Value):-
    Var1-Var2 #= Value.
apply_restriction(*, Var1, Var2, Value):-
    Var1*Var2 #= Value.
% no caso da divisão aplica uma restrição extra: os valores da divisão têm de ser inteiros
apply_restriction(/, Var1, Var2, Value):-
    % Var1/Var2 #= Value
    Var1 #= Value*Var2.

print_result(Operators, Operands):-
    write(Operators),write(Operands), nl.

% tradução de inteiros para sinais
numb_signal(1,+).
numb_signal(2,-).
numb_signal(3,*).
numb_signal(4,/).

% transforma uma lista de inteiros para uma lista de sinais
opsi_to_opss([],[]).
opsi_to_opss([H|T], [Sig|Temp]):-
  numb_signal(H, Sig),
  opsi_to_opss(T, Temp).