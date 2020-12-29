% test_Case(+Tips, -[Operators])
test_case(3  ,[-,-,+,+,-,+]).
test_case(4  ,[-,+,-,-,-,+,-,-]).
test_case(5  ,[-,+,+,-,+,+,-,-,+,-]).
test_case(6  ,[-,+,-,-,+,-,+,+,-,-,+,-]).
test_case(7  ,[-,-,+,-,+,-,-,+,-,+,+,-,+,+]).
test_case(8  ,[-,-,+,+,+,+,-,+,+,-,+,-,+,-,-,-]).
test_case(9  ,[*,+,+,-,+,+,+,*,+,*,+,+,*,-,-,+,-,*]).
test_case(10 ,[-,-,+,+,+,+,+,-,-,-,-,-,+,-,-,+,+,-,+,+]).
test_case(11 ,[-,-,+,-,-,+,-,+,+,-,+,-,-,+,+,+,-,+,+,+,-,+]).
test_case(12 ,[-,-,+,+,-,-,+,+,-,-,-,-,+,+,-,+,+,+,+,+,+,-,-,-]).
test_case(13 ,[-,-,-,-,+,-,-,+,-,-,-,+,-,+,+,-,+,-,+,-,-,+,+,-,-,-]).
test_case(14, [-,+,-,+,-,-,+,-,+,+,-,+,+,-,+,+,+,-,+,+,-,+,+,-,+,-,+,+]).
test_case(15, [-,-,+,-,-,+,+,-,+,+,+,-,-,+,-,+,+,-,+,-,-,+,-,-,+,-,-,+,-,+]).
/*
Necessário mudar working directory para pasta de projeto no SicStus
prolog:set_current_directory('C:/Data/Andre/Work/MIEIC_A3S1/PLOG/feup-plog-proj-2'), consult('C:/Data/Andre/Work/MIEIC_A3S1/PLOG/feup-plog-proj-2/src/goldstar.pl').
*/
save_all:-
    save_groups(3,6),       % Lower Bound e Upper Bound
    % save_find_sol(3,13,5),   % Lower Bound, Upper Bound, número de tentativas
    % save_groups(6,6),       % Lower Bound e Upper Bound
    write('\nAll Finished\n').

save_heuristics:-
    option_test(X),
    option_test_2(Y),
    option_test_3(Z),
    format('~w ~w ~w\n', [X, Y, Z]),
    save(5,1,1,X,Y,Z),
    fail.

save_heuristics_part_2:-
    option_test_2(Y),
    option_test_3(Z),
    format('~w ~w ~w\n', ['select()', Y, Z]),
    save(5,1,1,Y,Z),
    fail.

option_test(leftmost).
option_test(min).
option_test(max).
option_test(ff).
option_test(anti_first_fail).
option_test(occurrence).
option_test(ffc).
option_test(max_regret).
% option_test(variable(select_next(Affected))).

option_test_2(step).
option_test_2(enum).
option_test_2(bisect).
option_test_2(median).
option_test_2(middle).

option_test_3(up).
option_test_3(down).

% chama save_group com nº de pontas entre arg1 e arg2 -> [arg1, arg2]
save_groups(Upper, Upper):-
    save_group(Upper),
    write('\nSave Groups Finished\n\n').
save_groups(Current, U):-
    Current1 is Current+1,
    save_group(Current),
    save_groups(Current1, U).
% guarda, para um número de pontas, os resultados com restrições ou sem restrições, todos os resultados ou apenas 1
save_group(Tips):-
    save(Tips, 1, 1),
    save(Tips, 1, 0),
    save(Tips, 0, 1),
    save(Tips, 0, 0).

% procura confs aleatórias e soluções para estrelas de pontas entre [L, U]. Executa Attempts vezes
save_find_sol(L, U, Attempts):-
    save_find_sol(L, U, 1, Attempts),
    write('\nFind One Solution Finished\n\n').
save_find_sol(L, U, Attempts, Attempts):-
    call_save(L, U, Attempts),
    format('\nAttempt ~d Done\n', [Attempts]).
save_find_sol(L, U, Current, Attempts):-
    Current1 is Current+1,
    call_save(L, U, Current),
    format('\nAttempt ~d Done\n', [Current]),
    save_find_sol(L, U, Current1, Attempts).

% save de 2 argumentos guarda find_one_sol
call_save(Upper, Upper, Serial):-
    save(Upper, Serial).
call_save(Current, Upper, Serial):-
    Current1 is Current+1,
    save(Current, Serial),
    call_save(Current1, Upper, Serial).

% save de 3 argumentos guarda resutados de run
save(Tips, Rest, Cut):-
    Predicate =.. [run, Tips, Rest, Cut],
    file_name(Tips, Rest, Cut, FileName),
    format('Saving to ~w\n', [FileName]),
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
% save de 2 argumentos guarda resultados de find_1_solution
save(Tips, Attempt):-
    Predicate =.. [find_1_solution, Tips],

    number_chars(Tips, Y),
    atom_chars(TipsString, Y),
    number_chars(Attempt, X),
    atom_chars(AttemptString, X),

    atom_concat(TipsString, '_tips_find_one_attempt_', Temp1),
    atom_concat(Temp1, AttemptString, Temp2),
    atom_concat(Temp2, '.txt', FileName),

    format('Saving to ~w\n', [FileName]),
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
% save de 6 argumentos para guardar resultados de heuristica
save(Tips, Rest, Cut, X, Y, Z):-
    Predicate =.. [run, Tips, Rest, Cut, X, Y, Z],
    file_name(Tips, Rest, Cut, X, Y, Z, FileName),
    format('Saving to ~w\n', [FileName]),
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
% save de 5 argumentos para guardar resultados de heuristica com heuristica própria
save(Tips, Rest, Cut, Y, Z):-
    Predicate =.. [run, Tips, Rest, Cut, Y, Z],
    file_name(Tips, Rest, Cut, Y, Z, FileName),
    format('Saving to ~w\n', [FileName]),
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

% buscar todas as configurações para um dado numero de Tips, dependendo de Cut e Restrições nos Operadores
run(Tips, Restricted, Cut):-
    operators(Restricted, Tips, OpsInt),
    opsi_to_opss(OpsInt, Ops),
    gold_star(Cut, Ops),
    fail.
run(Tips, Restricted, Cut, X, Y, Z):-
    operators(Restricted, Tips, OpsInt),
    opsi_to_opss(OpsInt, Ops),
    gold_star(Cut, Ops, X, Y, Z),
    fail.
run(Tips, Restricted, Cut, Y, Z):-
    operators(Restricted, Tips, OpsInt),
    opsi_to_opss(OpsInt, Ops),
    gold_star(Cut, Ops, Y, Z),
    fail.

% Pesquisa configurações até encontrar uma que tenha solução
find_1_solution(Tips):-
    repeat,                     % repete para encontrar outra configuração
    operators(2, Tips, OpsInt), % configuração aleatória
    opsi_to_opss(OpsInt, Ops),  % converter de números para sinais
    write(Ops), nl,
    gold_star(1, Ops).          % soluciona

% file_name(+Tips, +Restricted, +Cut, -Filename)
file_name(Tips, Restricted, Cut, FileName):-
    number_chars(Tips, Y),
    atom_chars(TipsString, Y),
    restricted_string(Restricted, ResString),
    cut_string(Cut, CutString),
    atom_concat(TipsString, '_tips_', Temp),
    atom_concat(Temp, ResString, Temp2),
    atom_concat(Temp2, CutString, Temp3),
    atom_concat(Temp3, '.txt', FileName).
% file_name(+Tips, +Restricted, +Cut, +X, +Y, +Z, -Filename)
file_name(Tips, Restricted, Cut, X, Y, Z, FileName):-
    number_chars(Tips, TempVar),
    atom_chars(TipsString, TempVar),
    restricted_string(Restricted, ResString),
    cut_string(Cut, CutString),
    atom_concat(TipsString, '_tips_', Temp),
    atom_concat(Temp, ResString, Temp2),
    atom_concat(Temp2, CutString, Temp3),
    atom_concat(Temp3, '_', Temp4),
    atom_concat(Temp4, X, Temp5),
    atom_concat(Temp5, '_', Temp6),
    atom_concat(Temp6, Y, Temp7),
    atom_concat(Temp7, '_', Temp8),
    atom_concat(Temp8, Z, Temp9),
    atom_concat(Temp9, '.txt', FileName).
% file_name(+Tips, +Restricted, +Cut, +Y, +Z, -Filename)
file_name(Tips, Restricted, Cut, Y, Z, FileName):-
    number_chars(Tips, TempVar),
    atom_chars(TipsString, TempVar),
    restricted_string(Restricted, ResString),
    cut_string(Cut, CutString),
    atom_concat(TipsString, '_tips_', Temp),
    atom_concat(Temp, ResString, Temp2),
    atom_concat(Temp2, CutString, Temp3),
    atom_concat(Temp3, '_', Temp4),
    atom_concat(Temp4, 'variable()', Temp5),
    atom_concat(Temp5, '_', Temp6),
    atom_concat(Temp6, Y, Temp7),
    atom_concat(Temp7, '_', Temp8),
    atom_concat(Temp8, Z, Temp9),
    atom_concat(Temp9, '.txt', FileName).

restricted_string(1, 'restricted_').
restricted_string(0, 'unrestricted_').
cut_string(1, 'one_solution').
cut_string(0, 'all_solutions').
