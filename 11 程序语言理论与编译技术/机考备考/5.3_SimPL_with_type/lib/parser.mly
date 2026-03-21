%{
    open Ast
%}

%token <int> INT
%token <string> ID
%token TRUE FALSE
%token PLUS MINUS TIMES DIV LEQ EOF
%token LPAREN RPAREN
%token IF THEN ELSE
%token LET EQUALS IN

%nonassoc EQUALS (* 不存在结合性的说法 *)
%nonassoc IN (* 优先级比 else 低 *)
%nonassoc ELSE

%nonassoc LEQ (* 优先级低于算术运算，高于 else *)

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
    | TRUE { Bool (true) }
    | FALSE { Bool (false) }
    | expr TIMES expr { Binop (Mul, $1, $3) }
    | expr DIV expr   { Binop (Div, $1, $3) }
    | expr PLUS expr  { Binop (Add, $1, $3) }
    | expr MINUS expr { Binop (Sub, $1, $3) }
    | expr LEQ expr { Binop (Leq, $1, $3) }
    | IF expr THEN expr ELSE expr { If ($2, $4, $6) }
    | LET ID EQUALS expr IN expr { Let($2, $4, $6) }
    | LPAREN expr RPAREN { $2 }
;