father(terach, abraham).
father(terach, nachor).
father(terach, haran).
male(terach).
male(abraham).
male(haran).

main :- male(terach), writef('%t\n', [X]).
main :- father(terach, X), writef('%t\n', [X]).
