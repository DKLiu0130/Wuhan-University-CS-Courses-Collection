%{
    open Ast
%}

%token <int> INT
%token <string> ID
%token PLUS MINUS TIMES DIV EOF
%token LPAREN RPAREN
%token LEQ
%token TRUE FALSE
%token LET EQUALS IN
%token IF THEN ELSE 

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
    | INT { Int $1 }
    | ID { Var $1 }
    | TRUE { Bool true }
    | FALSE { Bool false}
    | expr LEQ expr   { Binop (Leq, $1, $3) }
    | expr TIMES expr { Binop (Mul, $1, $3) }
    | expr DIV expr   { Binop (Div, $1, $3) }
    | expr PLUS expr  { Binop (Add, $1, $3) }
    | expr MINUS expr { Binop (Sub, $1, $3) }
    | LET ID EQUALS expr IN expr  { Let ($2, $4, $6) }
    | IF expr THEN expr ELSE expr { If ($2, $4, $6) }
    | LPAREN expr RPAREN { $2 }
;