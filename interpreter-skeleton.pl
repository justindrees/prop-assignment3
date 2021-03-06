/***
A skeleton for Assignment 3 on PROP HT2014 at DSV/SU.
Peter Idestam-Almquist, 2014-12-23.
***/

:- [tokenizer].

run(InputFile,OutputFile):-
	tokenize(InputFile,Program),
	write('This is the Program: '), write(Program), write('\n'), /* Display result of tokenizer to help debugging. Remove before handing in assignment. */
	parse(ParseTree,Program,[]),
	open('outfile',write,OutputStream),
	write(OutputStream,'PARSE TREE:'), 
	nl(OutputStream), 
	writeln_term(OutputStream,0,ParseTree).

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

assignment(assignment(Identifier, assign_op, Expression, semicolon)) --> ident(Identifier), assign_op, expression(Expression), semicolon.

ident(ident(Variable)) --> [Variable], {atom(Variable)}.

assign_op --> [=].

expression(expression(Term, Operator, Expression)) --> term(Term), exp_operator(Operator), expression(Expression).
expression(expression(Term)) --> term(Term).

term(term(Factor, Operator, Term)) --> factor(Factor), operator(Operator), term(Term).
term(term(Factor)) --> factor(Factor).

factor(factor(Value)) --> value(Value).
factor(factor(Value, Operator, Term)) --> value(Value), operator(Operator), term(Term).
factor(factor(left_paren, Expression, right_paren)) --> left_paren, expression(Expression), right_paren.

value(int(Number)) --> [Number], {integer(Number)}.
value(variable(Variable)) --> [Variable], {atom(Variable)}.

exp_operator(add_op) --> [+].
exp_operator(sub_op) --> [-].
operator(mult_op) --> [*].
operator(div_op) --> [/].
left_paren --> ['('].
right_paren --> [')'].
semicolon --> [';'].

% Note: I'm not sure if this is the right way to implement the head for the parser.
% This is the only way I could figure out so that the output of the parser is printed to console so it's easier to debug.
parse(ParseTree, Program, []):-
	assignment(ParseTree,Program,[]),
	% The line below is for displaying the output to the console to check if the parser works. Remove before handing in the assignment.
	write('Output of parser:\n'), write(ParseTree), write('\n').
	
/***
evaluate(+ParseTree,+VariablesIn,-VariablesOut):-
	TODO: Implement an evaluate predicate that evaluates a parse-tree and 
	returns the state of the program after evaluation as a list of variables and 
	their values.
***/

% Define main so that the program builds.
main :- run('program1.txt', OutputFile), write(OutputFile).