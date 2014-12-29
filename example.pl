assignment --> variable(Vtype), gets, expr(Etype),
    { (Vtype = int, Etype = real)
      -> error('Type of right hand side not convertible to type of left-hand side')
      ;  true }.


expr(T) --> term(T1), addop(_Op), expr(T2),
	{ T1 = real -> T = real ;  T = T2 }.

expr(T) --> term(T).


term(T) --> factor(T1), mulop(Op), term(T2),
	{ (Op = mul)
	  -> (T1 = real -> T = real ; T = T2)
        ; (Op = div)
	  -> T = real
	; (Op = mod)
	  -> T = int, 
	     (T1 = real -> error('left operand should be of type integer') ; true),
	     (T2 = real -> error('right operand should be of type integer') ; true)
	}.
term(T) --> factor(T).

factor(T) --> variable(T).
factor(T) --> lparen, expr(T), rparen.

addop(add) --> ['+'].
addop(sub) --> ['-'].

mulop(mul) --> ['*'].
mulop(mul) --> ['times'].
mulop(mul) --> ['×'].
mulop(div) --> ['/'].
mulop(div) --> ['÷'].
mulop(mod) --> ['mod'].

gets --> [':='].
lparen --> ['('].
rparen --> [')'].

variable(int) --> [i].
variable(int) --> [j].
variable(int) --> [k].
variable(real) --> [x].
variable(real) --> [y].
variable(real) --> [z].
variable(int) --> [a].
variable(int) --> [b].
variable(int) --> [c].