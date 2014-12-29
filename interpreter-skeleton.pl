/***
A skeleton for Assignment 3 on PROP HT2014 at DSV/SU.
Peter Idestam-Almquist, 2014-12-23.
***/

:- [tokenizer].

run(InputFile,OutputFile):-
	tokenize(InputFile,Program),
	parse(ParseTree,Program,[]).
	% Uncomment the next two lines once evaluate is implemented
	%evaluate(ParseTree,[],VariablesOut),
	%output_result(OutputFile,ParseTree,VariablesOut).

output_result(OutputFile,ParseTree,Variables):- 
	open(OutputFile,write,OutputStream),
	write(OutputStream,'PARSE TREE:'), 
	nl(OutputStream), 
	writeln_term(OutputStream,0,ParseTree),
	nl(OutputStream), 
	write(OutputStream,'EVALUATION:'), 
	nl(OutputStream), 
	write_list(OutputStream,Variables), 
	close(OutputStream).
	
writeln_term(Stream,Tabs,int(X)):-
	write_tabs(Stream,Tabs), 
	writeln(Stream,int(X)).
writeln_term(Stream,Tabs,ident(X)):-
	write_tabs(Stream,Tabs), 
	writeln(Stream,ident(X)).
writeln_term(Stream,Tabs,Term):-
	functor(Term,_Functor,0), !,
	write_tabs(Stream,Tabs),
	writeln(Stream,Term).
writeln_term(Stream,Tabs1,Term):-
	functor(Term,Functor,Arity),
	write_tabs(Stream,Tabs1),
	writeln(Stream,Functor),
	Tabs2 is Tabs1 + 1,
	writeln_args(Stream,Tabs2,Term,1,Arity).
	
writeln_args(Stream,Tabs,Term,N,N):-
	arg(N,Term,Arg),
	writeln_term(Stream,Tabs,Arg).
writeln_args(Stream,Tabs,Term,N1,M):-
	arg(N1,Term,Arg),
	writeln_term(Stream,Tabs,Arg), 
	N2 is N1 + 1,
	writeln_args(Stream,Tabs,Term,N2,M).
	
write_tabs(_,0).
write_tabs(Stream,Num1):-
	write(Stream,'\t'),
	Num2 is Num1 - 1,
	write_tabs(Stream,Num2).

writeln(Stream,Term):-
	write(Stream,Term), 
	nl(Stream).
	
write_list(_Stream,[]). 
write_list(Stream,[Ident = Value|Vars]):-
	write(Stream,Ident),
	write(Stream,' = '),
	format(Stream,'~1f',Value), 
	nl(Stream), 
	write_list(Stream,Vars).
	
/***
parse(-ParseTree)-->
	TODO: Implement a definite clause grammar (DCG) defining our programming language,
	and returning a parse tree.
***/

% TODO: the DCG below is a work in progress. A lot of things are wrong. Needs fixing.
%assignment(assignment([Identifier,Expression])) --> assignment([Identifier,Expression]).
assignment(assignment([Identifier,Expression])) --> ident(Identifier), expression(Expression).
assignment([Identifier]) --> ident(Identifier).

ident(ident(Variable)) --> [Variable], {atom(Variable)}.

value(variable(Variable)) --> [Variable], {atom(Variable)}.
value(number(Number)) --> [Number], {number(Number)}.

expression(assign_op|Expression) --> assign_op, rest_expression(Expression).

rest_expression([Value]) --> value(Value).
%rest_expression([Value,Expression]) --> operator(Value), rest_expression(Expression).
rest_expression([operator(Operator,Value)|Expression]) --> operator(Operator), value(Value), rest_expression(Expression).
rest_expression([operator(Operator,Value)]) --> operator(Operator), value(Value).

assign_op --> [=].
operator(+) --> [+].
operator(-) --> [-].
operator(*) --> [*].
operator(/) --> ['/']. /* TODO: Fix. This doesn't work. */
left_paren --> ['(']. /* TODO: Check if this works. */
right_paren --> [')']. /* TODO: Check if this works. */
%operator(';') --> [';']. /* TODO: Fix. Make this work. */

expvalue(L,V) :- assignment(V,L,[]).

parse(ParseTree, Program, []):-
	%expvalue(Program, V),
	assignment(ParseTree,Program,[]),
	write('Output of parser: '), write(ParseTree), write('\n').
	%write('Not implemented yet').

/*** OLD CODE
assignment([Variable|Expression]) --> ident(Variable), expression(Expression).
 
ident(ident(Variable)) --> [Variable], {atom(Variable)}.

value(variable(Variable)) --> [Variable], {atom(Variable)}.
value(number(Number)) --> [Number], {number(Number)}.

expression(assign_op|Expression) --> assign_op, rest_expression(Expression).

rest_expression([Value|Expression]) --> operator(Value), rest_expression(Expression).
rest_expression([operator(Operator,Value)|Expression]) --> operator(Operator), value(Value), rest_expression(Expression).
rest_expression([operator(Operator,Value)]) --> operator(Operator), value(Value).

assign_op --> [=].
operator(+) --> [+].
operator(-) --> [-].
operator(*) --> [*].
*/

	
/***
evaluate(+ParseTree,+VariablesIn,-VariablesOut):-
	TODO: Implement an evaluate predicate that evaluates a parse-tree and 
	returns the state of the program after evaluation as a list of variables and 
	their values.
***/

% Define main so that the program builds
main :- run('program_test.txt', OutputFile), write(OutputFile).