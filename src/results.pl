/*
Necessário mudar working directory para pasta de projeto no SicStus 
prolog:set_current_directory('C:/Data/Andre/Work/MIEIC_A3S1/PLOG/feup-plog-proj-2'), consult('C:/Data/Andre/Work/MIEIC_A3S1/PLOG/feup-plog-proj-2/src/goldstar.pl').
*/
save_all:-
  % mudar working directory para "Resultados_save_all" antes de executar
  save(print_restricted_one_sol),
  save(print_restricted_all_sol),
  save(print_unrestricted_one_sol),
  save(print_unrestricted_all_sol),
  save(print_all_comb),
  write('\nAll Finished\n').

/*
save(operators)
save(print_all_comb)
save(save_1_solution)
*/
save(Predicate):-
  get_file_name(Predicate, FileName),
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
  
get_file_name(Predicate, FileName):-
  Predicate =.. L,
  nth0(0, L, Name),
  atom_concat(Name, '.txt', FileName).
  
  
% Usado sem cut em star, encontra todas as soluções para todas as disposições
% calcula operadores dentro de star sem usar restrições mas sim undos
print_all_comb:-
  star(0,_,_), fail.

/*
Com Cut em Star:
  - Arranja uma solução para cada disposição com restrições
*/
print_restricted_one_sol:-
  operators_rest(Opsi),
  opsi_to_opss(Opsi, Ops),
  star(1, Ops, _), fail.

/*
Sem Cut em Star:
  - Aplica restrições ás combinações de operadores e imprime todas as soluções 
  para todas as disposições
*/
print_restricted_all_sol:-
  operators_rest(Opsi),
  opsi_to_opss(Opsi, Ops),
  star(0, Ops, _), fail.

/*
Com Cut em Star:
  - Arranja uma solução para cada disposição sem restrições, 1.04m de resultados
*/
print_unrestricted_one_sol:-
  operators(Opsi),
  opsi_to_opss(Opsi, Ops),
  star(1, Ops, _), fail.

/*
Sem Cut em Star:
  - Arranja todas as soluções para todas as disposições sem restrições
*/
print_unrestricted_all_sol:-
  operators(Opsi),
  opsi_to_opss(Opsi, Ops),
  star(1, Ops, _), fail.