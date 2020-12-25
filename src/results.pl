/*
Necessário mudar working directory para pasta de projeto no SicStus 
prolog:set_current_directory('C:/Data/Andre/Work/MIEIC_A3S1/PLOG/feup-plog-proj-2'), consult('C:/Data/Andre/Work/MIEIC_A3S1/PLOG/feup-plog-proj-2/src/goldstar.pl').
*/
save_all:-
    save_group(3),
    save_group(4),
    save_group(5),
    write('\nAll Finished\n').

save_find_sol:-
    save(find_1_solution, 3, _, _),
    save(find_1_solution, 4, _, _),
    save(find_1_solution, 5, _, _),
    save(find_1_solution, 6, _, _),
    save(find_1_solution, 7, _, _),
    save(find_1_solution, 8, _, _),
    save(find_1_solution, 9, _, _),
    save(find_1_solution, 10, _, _),
    write('\nAll Finished\n').

save_group(Tips):-
    save(run, Tips, 1, 1),
    save(run, Tips, 1, 0),
    save(run, Tips, 0, 1),
    save(run, Tips, 0, 0).

save(PredicateName, Tips, Rest, Cut):-
    Predicate =.. [PredicateName, Tips, Rest, Cut],
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

run(Tips, Restricted, Cut):-
    operators(Restricted, Tips, OpsInt),
    opsi_to_opss(OpsInt, Ops),
    gold_star(Cut, Ops),
    fail.

find_1_solution(Tips, _, _):-
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
    
restricted_string(1, 'restricted_').
restricted_string(0, 'unrestricted_').
cut_string(1, 'one_solution').
cut_string(0, 'all_solutions').