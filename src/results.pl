/*
Necessário mudar working directory para pasta de projeto no SicStus 
prolog:set_current_directory('C:/Data/Andre/Work/MIEIC_A3S1/PLOG/feup-plog-proj-2'), consult('C:/Data/Andre/Work/MIEIC_A3S1/PLOG/feup-plog-proj-2/src/goldstar.pl').
*/
save_all:-
    save_groups(3,6),       % Lower Bound e Upper Bound
    save_find_sol(3,9,5),   % Lower Bound, Upper Bound, número de tentativas
    write('\nAll Finished\n').

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


% buscar todas as configurações para um dado numero de Tips, dependendo de Cut e Restrições nos Operadores
run(Tips, Restricted, Cut):-
    operators(Restricted, Tips, OpsInt),
    opsi_to_opss(OpsInt, Ops),
    gold_star(Cut, Ops),
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
    
restricted_string(1, 'restricted_').
restricted_string(0, 'unrestricted_').
cut_string(1, 'one_solution').
cut_string(0, 'all_solutions').