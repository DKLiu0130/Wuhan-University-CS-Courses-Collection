%{
    open Ast
%}

%token <int> INT
%token PLUS MINUS TIMES DIV EOF
%token LPAREN RPAREN


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
    | expr TIMES expr { Binop (Mul, $1, $3) }
    | expr DIV expr   { Binop (Div, $1, $3) }
    | expr PLUS expr  { Binop (Add, $1, $3) }
    | expr MINUS expr { Binop (Sub, $1, $3) }
    | LPAREN expr RPAREN { $2 }
;
