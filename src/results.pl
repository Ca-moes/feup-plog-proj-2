% test_case(+Tips, -[Operators])
% test cases used for menu option 2
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
test_case(14 ,[-,+,-,+,-,-,+,-,+,+,-,+,+,-,+,+,+,-,+,+,-,+,+,-,+,-,+,+]).
test_case(15 ,[-,-,+,-,-,+,+,-,+,+,+,-,-,+,-,+,+,-,+,-,-,+,-,-,+,-,-,+,-,+]).
test_case(16 ,[-,+,-,+,+,-,+,+,-,+,-,-,-,-,-,+,+,-,-,+,+,-,+,+,+,+,+,-,+,-,+,-]).

% saves all solutions configurations in the body of this predicate
save_all:-
    save_groups(3,6),       % Lower Bound e Upper Bound
    % save_find_sol(3,13,5),   % Lower Bound, Upper Bound, número de tentativas
    % save_groups(6,6),       % Lower Bound e Upper Bound
    write('\nAll Finished\n').

% tests heuristics on operators generation and saves the results
save_heuristics_ops:-
    option_test(X),
    option_test_2(Y),
    option_test_3(Z),
    format('~w ~w ~w\n', [X, Y, Z]),
    save_ops(6,X,Y,Z),
    fail.
% tests heuristics on solver and saves the results
save_heuristics:-
    option_test(X),
    option_test_2(Y),
    option_test_3(Z),
    save(5,1,1,X,Y,Z),
    fail.
% tests variable(Sel) heuristics on solver and saves the results
save_heuristics_part_2:-
    option_test_2(Y),
    option_test_3(Z),
    format('~w ~w ~w\n', ['select()', Y, Z]),
    save(5,1,1,Y,Z),
    fail.
% All options available for labeling heuristics
option_test(leftmost).
option_test(min).
option_test(max).
option_test(ff).
option_test(anti_first_fail).
option_test(occurrence).
option_test(ffc).
option_test(max_regret).
option_test_2(step).
option_test_2(enum).
option_test_2(bisect).
option_test_2(median).
option_test_2(middle).
option_test_3(up).
option_test_3(down).

% save_groups base case
save_groups(Upper, Upper):-
    save_group(Upper),
    write('\nSave Groups Finished\n\n').
% calls save_group with currents tips number ans goes to next
save_groups(Current, U):-
    Current1 is Current+1,
    save_group(Current),
    save_groups(Current1, U).
% For a given tips number, saves all solutions or just one solution per configuration, with restrictions or without restrictions on operators
save_group(Tips):-
    save(Tips, 1, 1),
    save(Tips, 1, 0),
    save(Tips, 0, 1),
    save(Tips, 0, 0).

% Searches for random configurations with stars between L and U tips. Runs Attempts times
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

% Saves the results of find_one_sol 
call_save(Upper, Upper, Serial):-
    save(Upper, Serial).
call_save(Current, Upper, Serial):-
    Current1 is Current+1,
    save(Current, Serial),
    call_save(Current1, Upper, Serial).

% Saves results of run with 3 arguments
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
% Saves results of find_1_solution
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
% Saves results of run with 6 arguments
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
% Saves results of run with 5 arguments
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
% Saves results of save_ops 
save_ops(Tips, X, Y, Z):-
    Predicate =.. [run_ops, Tips, X, Y, Z],
    file_name_ops(Tips, X, Y, Z, FileName),
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

% Gets operators, converts them and searches for a solution
run(Tips, Restricted, Cut):-
    operators(Restricted, Tips, OpsInt),
    opsi_to_opss(OpsInt, Ops),
    gold_star(Cut, Ops),
    fail.
% Run predicate to test heuristics
run(Tips, Restricted, Cut, X, Y, Z):-
    operators(Restricted, Tips, OpsInt),
    opsi_to_opss(OpsInt, Ops),
    gold_star(Cut, Ops, X, Y, Z),
    fail.
% Run predicate to test heuristics with variable(Sel)
run(Tips, Restricted, Cut, Y, Z):-
    operators(Restricted, Tips, OpsInt),
    opsi_to_opss(OpsInt, Ops),
    gold_star(Cut, Ops, Y, Z),
    fail.
% Run predicate to test heuristics on finding configurations
run_ops(Tips, X, Y, Z):-
    operators(1,Tips,X,Y,Z,Opsi),
    opsi_to_opss(Opsi, Ops),
    write(Ops),nl,
    fail.

% Searchs configurations until it finds one that has a solution
find_1_solution(Tips):-
    repeat,                     % repeats to find another configuration
    operators(2, Tips, OpsInt), % random configuration
    opsi_to_opss(OpsInt, Ops),  % converts from numbers to operators
    write(Ops), nl,
    gold_star(1, Ops).          % solves

% file_name(+Tips, +Restricted, +Cut, -Filename)
% creates a custom filename
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
% file_name_ops(+Tips, +X, +Y, +Z, -Filename)
file_name_ops(Tips, X, Y, Z, FileName):-
    number_chars(Tips, TempVar),
    atom_chars(TipsString, TempVar),
    atom_concat(TipsString, '_tips_ops_', Temp4),
    atom_concat(Temp4, X, Temp5),
    atom_concat(Temp5, '_', Temp6),
    atom_concat(Temp6, Y, Temp7),
    atom_concat(Temp7, '_', Temp8),
    atom_concat(Temp8, Z, Temp9),
    atom_concat(Temp9, '.txt', FileName).

% arguments for custom file_name
restricted_string(1, 'restricted_').
restricted_string(0, 'unrestricted_').
cut_string(1, 'one_solution').
cut_string(0, 'all_solutions').
