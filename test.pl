father(terach, abraham).
father(terach, nachor).
father(terach, haran).
male(terach).
male(abraham).
male(haran).

main :- father(terach, X), writef('%t\n', [X]).
