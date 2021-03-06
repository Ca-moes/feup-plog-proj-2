:- compile('results.pl').
:- compile('menus.pl').
:- use_module(library(clpfd)).
:- use_module(library(lists)).
:- use_module(library(random)).

% operators(+Restricted, +Tips, +X, +Y, +Z, -Operators)
% operators predicate to test diferent heuristics combinations
operators(1, Tips, X, Y, Z, Ops):-
    % Definição das Variáveis e Domínios
    Tips >= 3,
    OperNumb is Tips*2,
    length(Ops, OperNumb),
    domain(Ops, 1, 4),
    % Colocação das Restrições
    element(1, Ops, Op1i),
    bigger(Op1i, Ops), !,
    % Pesquisa da solução
    labeling([X, Y, Z], Ops).
% operators(+Restricted, +Tips, -Operators)
% operators predicate to create restricted operator configurations
operators(1, Tips, Ops):-
    % Definição das Variáveis e Domínios
    Tips >= 3,
    OperNumb is Tips*2,
    length(Ops, OperNumb),
    domain(Ops, 1, 4),
    % Colocação das Restrições
    element(1, Ops, Op1i),
    bigger(Op1i, Ops),
    % Pesquisa da solução
    labeling([occurrence, enum, up], Ops).
% operators predicate to create unrestricted operator configurations
operators(0, Tips, Ops):-
    % Definição das Variáveis e Domínios
    Tips >= 3,
    OperNumb is Tips*2,
    length(Ops, OperNumb),
    domain(Ops, 1, 4),
    % Sem Colocação das Restrições
    % Pesquisa da solução
    labeling([], Ops).
% operators predicate to create pseudo random operator configurations
operators(2, Tips, [R|OpsPart]):-
    Tips >= 3,
    OperNUmb is Tips*2-1,
    random(2, 5, R), % restrição bigger
    UpperB is R+1,
    create_list(OperNUmb, UpperB, OpsPart).
    
% helper predicate to create random  list
create_list(0, _, []).
create_list(Size, UpperB, [Result|TempReturn]):-
    Size > 0,
    Size1 is Size-1,
    random(1,UpperB, Result),
    create_list(Size1, UpperB, TempReturn).

% predicate to impose bigger restriction
bigger(_, []).
bigger(Op1, [Op | Rest]) :-
    Op1 #>= Op,
    bigger(Op1, Rest).

% gold_star(+Cut, +Operators)
% Solver predicate to find a solution given a Operators configuration
gold_star(Cut, Operators):-
    % Variable and Domain Definition 
    length(Operators, Length),
    length(Result, Length),
    Upper is Length-1,
    domain(Result, 0, Upper),
    %get_divisions(Operators, Result, Affected),  <- use with custom variable(Sel)

    % Restrictions
    all_distinct(Result),
    first_restrictions(Operators, Result),
    remaining_restrictions(Operators, Result), 
    !, % in case labelling fails, exits predicate

    % Solution Search
    labeling([min, middle, up], Result),
    print_result(Operators, Result),
    ((Cut == 1, !);(Cut == 0)). % Cut to find only 1 solution, no Cut to find all solutions for a configuration
% Solver predicate with extra arguments to test heuristics combinations
gold_star(Cut, Operators, X, Y, Z):-
    % Variable and Domain Definition 
    length(Operators, Length),
    length(Result, Length),
    Upper is Length-1,
    domain(Result, 0, Upper),

    % Restrictions
    all_distinct(Result),
    first_restrictions(Operators, Result),
    remaining_restrictions(Operators, Result), 
    !, % in case labelling fails, exits predicate

    % Solution Search
    labeling([X, Y, Z], Result),
    print_result(Operators, Result),
    ((Cut == 1, !);(Cut == 0)). % Cut to find only 1 solution, no Cut to find all solutions for a configuration
% Solver predicate with extra arguments to test heuristics combinations using custim variable(Sel)
gold_star(Cut, Operators, Y, Z):-
    % Variable and Domain Definition 
    length(Operators, Length),
    length(Result, Length),
    Upper is Length-1,
    domain(Result, 0, Upper),
    get_divisions(Operators, Result, Affected),

    % Restrictions
    all_distinct(Result),
    first_restrictions(Operators, Result),
    remaining_restrictions(Operators, Result), 
    !, % in case labelling fails, exits predicate

    % Solution Search
    labeling([variable(select_next(Affected)), Y, Z], Result),
    print_result(Operators, Result),
    ((Cut == 1, !);(Cut == 0)). % Cut to find only 1 solution, no Cut to find all solutions for a configuration
    
% Predicate needed with variable(Sel) to finds Operands affected by divisions
% predicate in case the first operator is a division
get_divisions(Operators, Operands, Affected):-
    nth0(0, Operators, Op0),
    Op0 == /,
    length(Operands, Length),
    Length1 is Length-1,
    element(1, Operands, A),
    element(Length, Operands, Z),
    get_divisions_rest(Length1, Operators, Operands, Return, Return2),
    Affected1 = [A, Z | Return],
    Affected2 = [0, Length1 | Return2],
    del_dups(Affected2, Affected1, Affected).
% predicate in case the first operator isn't a division
get_divisions(Operators, Operands, Affected):-
    length(Operands, Length),
    Length1 is Length-1,
    get_divisions_rest(Length1, Operators, Operands, Return, Return2),
    del_dups(Return2, Return, Affected).
% predicate to return the vars afected by divison ant their indexes
get_divisions_rest(0,_,_,[],[]).
get_divisions_rest(Index, Operators, Operands, [A, B | Return1], [Index, Index1|Return2]):-
    Index1 is Index-1,
    Index2 is Index+1,
    nth0(Index, Operators, Op),
    Op == /,
    element(Index2, Operands, A),
    element(Index, Operands, B),
    get_divisions_rest(Index1, Operators, Operands, Return1, Return2).
get_divisions_rest(Index, Operators, Operands, Return1, Return2):-
    Index1 is Index-1,
    get_divisions_rest(Index1, Operators, Operands, Return1, Return2).
% predicate to delete duplicates from a list, given the index list
del_dups([],_,[]).
del_dups(Lista1, ListaMid, Lista2) :-
    Lista1 = [H|T],
    ListaMid = [H2|T2],
    \+member(H,T),
    append([H2], L2, Lista2),
    del_dups(T, T2, L2).
del_dups(Lista1, ListaMid, Lista2) :-
    Lista1 = [_|T],
    ListaMid = [_|T2],
    del_dups(T, T2, Lista2).

% Predicate Sel to use in variable(Sel)
select_next(Param, ListOfVars, Var, Rest):-
    select_var(Param, ListOfVars, Var, Rest), !.

% Predicate to select the next variable
select_var([], ListOfVars, Var, Rest):-
    random_select(Var, ListOfVars, Rest),
    \+ number(Var).
select_var([H|_], ListOfVars, H, Rest):-
    \+ number(H),
    element(_, ListOfVars, H),
    list_without_elem(H, ListOfVars, Rest).
select_var([_|T], ListOfVars, Result, Rest):-
    select_var(T, ListOfVars, Result, Rest).

% predicate to get the rest after choosing a variable
list_without_elem(_, [], []).
list_without_elem(Elem, [H|T], Result):-
    Elem == H,
    list_without_elem(Elem, T, Result).
list_without_elem(Elem, [H|T], [H|Result]):-
    list_without_elem(Elem, T, Result).

% predicate to impose the initials restrictions
first_restrictions(Operators, Operands):-
    length(Operators, Length),
    Last_1 is Length,
    Last_2 is Length-1, % Last_1 nth0
    Last_3 is Length-2,
    Last_4 is Length-3, % Last_3 nth0

    element(1, Operands, A),
    element(2, Operands, B),
    element(3, Operands, C),
    element(4, Operands, D),
    element(5, Operands, E),
    element(Last_1, Operands, LetterL1),
    element(Last_2, Operands, LetterL2),
    element(Last_3, Operands, LetterL3),
    element(Last_4, Operands, LetterL4),
    nth0(0, Operators, Op0i),
    nth0(1, Operators, Op1i),
    nth0(2, Operators, Op2i),
    nth0(4, Operators, Op4i),
    nth0(Last_2, Operators, OpL1i),
    nth0(Last_4, Operators, OpL3i),
    %% Restrictions common to all
    %%% First: A (Op1) B = D (Op4) E
    apply_restriction(Op1i, A, B, Op4i, D, E),
    %%% Second: L4 (OpL3) L3 = L1 (Op0) A
    apply_restriction(OpL3i, LetterL4, LetterL3, Op0i, LetterL1, A),
    %%% Third: L2 (OpL1) L1 = B (Op2) C
    apply_restriction(OpL1i, LetterL2, LetterL1, Op2i, B, C).
% predicate to apply the remaining restrictions
remaining_restrictions(Operators, Operands):-
    [_,_|ListRest] = Operands,
    apply_remaining_restrictions(Operators, ListRest, 6, 3).
% To prevent adding restrictions with 3 tips or less 
apply_remaining_restrictions(Operators, _, _, _):-
    length(Operators, Len),
    Len =< 6.
% In case it's adding the last restriction, stops the recursion and check if Index1 is the last but one index
apply_remaining_restrictions(Operators, Operands, Index1, Index2):-
    length(Operators, OpsL),
    Test is OpsL - 2,
    Index1 == Test,
    apply_rem_rest_helper(Operators, Operands, Index1, Index2).
% Applies the restriciton, limits the operand list, searches the next indexes and continues the recursivity
apply_remaining_restrictions(Operators, Operands, Index1, Index2):-
    apply_rem_rest_helper(Operators, Operands, Index1, Index2),    
    [_,_|OperandsRest] = Operands,
    NewIndex1 is Index1+2,
    NewIndex2 is Index2+2,
    apply_remaining_restrictions(Operators, OperandsRest, NewIndex1, NewIndex2).
% Predicate that declares the restriction to apply
apply_rem_rest_helper(Operators, Operands, Index1, Index2):-
    element(1, Operands, D),
    element(2, Operands, C),
    element(4, Operands, B),
    element(5, Operands, A),
    nth0(Index1, Operators, Op1),
    nth0(Index2, Operators, Op2),
    apply_restriction(Op1, A, B, Op2, C, D).

% Apply restrictions in the form of equations
apply_restriction(Op1, Var1, Var2, Op2, Var3, Var4):-
    apply_restriction(Op1, Var1, Var2, Value),
    apply_restriction(Op2, Var3, Var4, Value).
apply_restriction(+, Var1, Var2, Value):-
    Var1+Var2 #= Value.
apply_restriction(-, Var1, Var2, Value):-
    Var1-Var2 #= Value.
apply_restriction(*, Var1, Var2, Value):-
    Var1*Var2 #= Value.
% in case of division a extra restrictions applies: the result must be an integer
apply_restriction(/, Var1, Var2, Value):-
    % Var1/Var2 #= Value
    Var1 #= Value*Var2.

% prints the operators ans operands in the form of 2 lists
print_result(Operators, Operands):-
    write(Operators),write(Operands), nl.

% translations from integers to operators
numb_signal(1,+).
numb_signal(2,-).
numb_signal(3,*).
numb_signal(4,/).

% transforms a list of integers to a list of operators
opsi_to_opss([],[]).
opsi_to_opss([H|T], [Sig|Temp]):-
  numb_signal(H, Sig),
  opsi_to_opss(T, Temp).

% predicate to print a 5 tipped star and its corresponding lists
print_star(Ops, Operands):-
    nth0(0, Operands, A),
    nth0(1, Operands, B),
    nth0(2, Operands, C),
    nth0(3, Operands, D),
    nth0(4, Operands, E),
    nth0(5, Operands, F),
    nth0(6, Operands, G),
    nth0(7, Operands, H),
    nth0(8, Operands, I),
    nth0(9, Operands, J),
    nth0(0, Ops, Op0),
    nth0(1, Ops, Op1),
    nth0(2, Ops, Op2),
    nth0(3, Ops, Op3),
    nth0(4, Ops, Op4),
    nth0(5, Ops, Op5),
    nth0(6, Ops, Op6),
    nth0(7, Ops, Op7),
    nth0(8, Ops, Op8),
    nth0(9, Ops, Op9),
    write('                                                 '), nl, 
    format('                   ~d                           ', [A]), nl,
    write('                                                 '), nl,
    format('                ~w     ~w                       ', [Op0, Op1]), nl,
    write('                                                 '), nl, 
    write('                                                 '), nl,
    format('~d      ~w      ~d    =    ~d      ~w       ~d  ', [I,Op9,J,B,Op2,C]), nl,
    write('                                                 '), nl, 
    format('    ~w       =              =       ~w          ', [Op8, Op3]), nl,
    write('                                                 '), nl, 
    format('         ~d                   ~d                ', [H,D]), nl,
    write('             =          =                        '), nl, 
    write('                                                 '), nl, 
    format('      ~w            ~d            ~w            ', [Op7,F,Op4]), nl,
    write('                                                 '), nl, 
    format('           ~w              ~w                   ', [Op6, Op5]), nl,
    write('                                                 '), nl, 
    format('   ~d                               ~d          ', [G,E]), nl,
    write('                                                 '), nl,
    print_result(Ops, Operands).