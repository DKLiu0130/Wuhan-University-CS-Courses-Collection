// <stmt>      ::= 
//               | <expr> ";" <stmt>                          (* 表达式语句 *)
//               | <expr>

// <expr>      ::= <literal>
//               | <identifier>
//               | "(" <binary-op> <expr> <expr> ")"   (* 二元运算 *)
//               | "(" <unary-op> <expr> ")"           (* 一元运算 *)
//               | "if" <expr> "then" <expr> "else" <expr>  (* 条件语句 *)

// <literal>   ::= <integer> | <boolean>
// <integer>   ::= [0-9]+
// <boolean>   ::= "true" | "false"
// <identifier>::= [a-zA-Z_][a-zA-Z0-9_]*

// <binary-op> ::= "+" | "-" | "*" | "/"     (* 算术运算 *)
//               | "==" | "!=" | "<" | ">"   (* 比较运算 *)
//               | "&&" | "||"               (* 逻辑运算 *)

// <unary-op>  ::= "!" | "-"                     (* 逻辑非, 负号*)

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
%token SEMICOLON
%token EQUAL NOTEQUAL GREATER LESS LAND LOR NOT

%nonassoc EQUALS (* 不存在结合性的说法 *)
%nonassoc IN (* 优先级比 else 低 *)
%nonassoc ELSE

%left LAND LOR
%nonassoc LEQ EQUAL NOTEQUAL GREATER LESS (* 优先级低于算术运算，高于 else *)

%left PLUS MINUS
%left TIMES DIV
%right NOT UOP_MINUS

%start program
%type <Ast.stmt> program
%%

program:
    stmts EOF { $1 }
;

stmts:
    | stmt_list { StmtList ($1) }

stmt_list:
    | expr SEMICOLON stmt_list { $1 :: $3 }
    | expr                     { [$1] }

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
    | expr GREATER expr { Binop (Greater, $1, $3) }
    | expr LESS expr { Binop (Less, $1, $3) }
    | expr EQUAL expr { Binop (Eq, $1, $3) }
    | expr NOTEQUAL expr { Binop (Neq, $1, $3) }
    | expr LAND expr { Binop (Land, $1, $3) }
    | expr LOR expr { Binop (Lor, $1, $3) }
    | NOT expr { Unop (Not, $2) }
    | MINUS expr { Unop (Minus, $2)} %prec UOP_MINUS
    | IF expr THEN expr ELSE expr { If ($2, $4, $6) }
    | LET ID EQUALS expr IN expr { Let($2, $4, $6) }
    | LPAREN expr RPAREN { $2 }
;