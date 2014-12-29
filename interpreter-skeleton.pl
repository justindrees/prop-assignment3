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
%assignment([Identifier,Expression]) --> ident(Identifier), expression(Expression).

%assignment(assignment([Identifier,Expression])) --> ident(Identifier), expression(Expression).
%assignment(assignment(Identifier,Expression)) --> ident(Identifier), assign_op(Expression).
assignment(assignment(Identifier, assign_op, Expression)) --> ident(Identifier), assign_op, expression(Expression).

ident(ident(Variable)) --> [Variable], {atom(Variable)}.

%assign_op([assign_op,Expression]) --> assign_op, expression(Expression).
assign_op --> [=].

value(variable(Variable)) --> [Variable], {atom(Variable)}.
value(number(Number)) --> [Number], {number(Number)}.

%expression(expression([assign_op|Expression])) --> assign_op, term(Expression).
%expression(expression([Value|Expression])) --> assign_op, term(Value).
expression(expression([Term])) --> term(Term).

term([Value]) --> value(Value).
%rest_expression([Value,Expression]) --> operator(Value), term(Expression).
term(term([operator(Operator,Value)|Expression])) --> operator(Operator), value(Value), term(Expression).
term(term([operator(Operator,Value)])) --> operator(Operator), value(Value).

equal --> ['='].
operator(+) --> [+].
operator(-) --> [-].
operator(*) --> [*].
operator(/) --> ['/']. /* TODO: Fix. This doesn't work. */
left_paren --> ['(']. /* TODO: Check if this works. */
right_paren --> [')']. /* TODO: Check if this works. */
semicolon --> [';']. /* TODO: Make this work. */


parse(ParseTree, Program, []):-
	assignment(ParseTree,Program,[]),
	% The line below is for displaying the output to the console to check if the parser works. Remove before handing in the assignment.
	write('Output of parser: '), write(ParseTree), write('\n').
	
/***
evaluate(+ParseTree,+VariablesIn,-VariablesOut):-
	TODO: Implement an evaluate predicate that evaluates a parse-tree and 
	returns the state of the program after evaluation as a list of variables and 
	their values.
***/

% Define main so that the program builds.
% Using 'program_test.txt' right now while implementing since it has a simpler assignment statement than 'program1.txt'
% Change'program_test.txt' to 'program1.txt' before handing in the assignment.
main :- run('program_test.txt', OutputFile), write(OutputFile).