%{
    open Ast

(** [make_apply e [e1; e2; ...]] makes the application  
    [e e1 e2 ...]).  Requires: the list argument is non-empty. *)
let rec make_apply e = function
  | [] -> failwith "precondition violated"
  | [e'] -> App (e, e')
	| h :: ((_ :: _) as t) -> make_apply (App (e, h)) t
%}

%token <int> INT
%token <string> ID
%token PLUS MINUS TIMES DIV EOF
%token LPAREN RPAREN
%token LEQ
%token TRUE FALSE
%token LET EQUALS IN
%token IF THEN ELSE 
%token FUNC ARROW

%nonassoc IN
%nonassoc ELSE
%left LEQ
%left PLUS MINUS
%left TIMES DIV

%start main
%type <Ast.expr> main
%%

main:
    expr EOF { $1 }
;

expr:
    | simpl_expr { $1 }
    | simpl_expr simpl_expr+ { make_apply $1 $2 }
    | FUNC ID ARROW expr { Func ($2, $4) }
;

simpl_expr:
    | INT { Int $1 }
    | ID { Var $1 }
    | TRUE { Bool true }
    | FALSE { Bool false}
    | simpl_expr LEQ simpl_expr   { Binop (Leq, $1, $3) }
    | simpl_expr TIMES simpl_expr { Binop (Mul, $1, $3) }
    | simpl_expr DIV simpl_expr   { Binop (Div, $1, $3) }
    | simpl_expr PLUS simpl_expr  { Binop (Add, $1, $3) }
    | simpl_expr MINUS simpl_expr { Binop (Sub, $1, $3) }
    | LET ID EQUALS simpl_expr IN simpl_expr  { Let ($2, $4, $6) }
    | IF simpl_expr THEN simpl_expr ELSE simpl_expr { If ($2, $4, $6) }
    | LPAREN expr RPAREN { $2 }
;