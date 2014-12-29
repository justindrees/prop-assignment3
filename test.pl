% This file is just for testing Prolog.
% Delete this file before handing in the assignment.
father(terach, abraham).
father(terach, nachor).
father(terach, haran).
male(terach).
male(abraham).
male(haran).

expression([Value]) --> value(Value).
expression([Value|Expression]) --> value(Value), rest_expression(Expression).
value(number(Number)) --> [Number], {number(Number)}.
value(variable(Variable)) --> [Variable], {atom(Variable)}.
rest_expression([operator(Operator,Value)|Expression]) --> operator(Operator), value(Value), rest_expression(Expression).
rest_expression([operator(Operator,Value)]) --> operator(Operator), value(Value).
operator(+) --> [+].
operator(-) --> [-].

expvalue(L,V) :- expression(V,L,[]).

main :- father(terach, X), write(X), nl, fail.
