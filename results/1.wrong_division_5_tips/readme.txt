Nestes resultados só é testada a estrela de 5 pontas. Na altura não era feita análise dimensional.
Estes resultados estão parcialmente incorretos, porque as divisões são arredondadas á unidade, fazendo com que haja mais configurações do que o suposto.
As divisões têm de resultar num número inteiro. 

Para dar fix a isto trocou-se a restrição:
apply_restriction(/, Var1, Var2, Value):-
    Var1/Var2 #= Value.

Para:
apply_restriction(/, Var1, Var2, Value):-
    Var1 #= Value*Var2.