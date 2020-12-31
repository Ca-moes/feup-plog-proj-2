% initial predicate to call the main menu
start:-
    clear,
    main_menu.

% main menu 
main_menu:-
    write('\nMain Menu'), nl, nl,
    write('1 - Input Operators'), nl,
    write('2 - Show Solver'), nl,
    write('3 - Find Solution (Random Config)'), nl,
    write('4 - DevOps - Save Results'), nl,
    write('5 - DevOps - Save Heuristics Solver'), nl,
    write('6 - DevOps - Save Heuristics Ops'), nl,
    write('0 - Exit'), nl,
    read_number(0, 6, Number),
    menu_option(Number).

% different main menu options
menu_option(0):-
    write('bye'),
    halt.
menu_option(1):-
    write('Exit program and call: goldstar(1,Ops) with Ops beeing a list of size 2*n of Operators of your choice : [+,-,*,/,+,-,*,/]\n'),
    main_menu.
menu_option(2):-
    write('How many tips?'), nl,
    read_number(3,16, Number),
    menu_2(Number),
    main_menu.
menu_option(3):-
    write('How many tips?'), nl,
    read_number(3,20, Number),
    menu_3(Number),
    main_menu.
menu_option(4):-
    write('Nao te esquecas de mudar working directory\n'),
    save_all.
menu_option(5):-
    write('Nao te esquecas de mudar working directory\n'),
    save_heuristics_part_2;
    save_heuristics.
menu_option(6):-
    write('Nao te esquecas de mudar working directory\n'),
    save_heuristics_ops.

% Second Menu option to solve a given configuration
menu_2(0).
menu_2(Number):-
    test_case(Number, Ops),
    statistics(runtime, [T0|_]),
    gold_star(1, Ops),
    statistics(runtime, [T1|_]),
    T is T1 - T0,
    format('Calculating ~d tips took ~3d sec.~n', [Number, T]).
% Third Menu Option to find a configuration with a solution
menu_3(0).
menu_3(Number):-
    statistics(runtime, [T0|_]),
    find_1_solution(Number),
    statistics(runtime, [T1|_]),
    T is T1 - T0,
    format('Find one Solution -  ~d tips took ~3d sec.~n', [Number, T]).

/*-----------  Inputs  ------------*/

% read_number(+LowerBound, +UpperBound, -Number)
% used in menus to read inputs between the Lower and Upper Bounds
read_number(LowerBound, UpperBound, Number):-
    format('| Choose an Option (~d-~d) - ', [LowerBound, UpperBound]),
    analyse_number(LowerBound, UpperBound, Number).
read_number(LowerBound, UpperBound, Number):-
    write('Not a valid number, try again\n'),
    read_number(LowerBound, UpperBound, Number).

% checks if a number is between the lower and upper bounds
analyse_number(L, U, Numb):-
    read_line(Codes),
    code_to_numb(Codes, Numbs),
    merge(Numbs, Numb),
    ((Numb =< U, Numb >= L) ; (Numb == 0)).

% transforms codes received to numbers
code_to_numb([],[]).
code_to_numb([X|Rest], [Numb|Temp]):-
    code_number(X, Numb),
    code_to_numb(Rest, Temp).

% merges numbers read to become one
merge(Digits, Result) :- merge(Digits, 0, Result).
merge([X|Xs], Prefix, Result) :-
    Prefix1 is Prefix * 10 + X,
    merge(Xs, Prefix1, Result).
merge([], Result, Result).

% ASCII code and respective decimal number
code_number(48, 0).
code_number(49, 1).
code_number(50, 2).
code_number(51, 3).
code_number(52, 4).
code_number(53, 5).
code_number(54, 6).
code_number(55, 7).
code_number(56, 8).
code_number(57, 9).

% clear/0
% Clears the screen, for better user experience (UX)
clear :- write('\33\[2J').
