test:-
    gold_star([1,2,3,4,1,2,3,4,1,2]).

gold_star(Operators):-
    length(Operators, Length),
    write(Length).




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