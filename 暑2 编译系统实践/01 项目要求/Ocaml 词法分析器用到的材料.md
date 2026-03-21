# Ocaml 词法分析器用到的材料

```
compunit → funcdef compunit_tail
compunit_tail → funcdef compunit_tail | /* empty */

stmt → block SEMICOLON
     | expr SEMICOLON
     | ID "=" expr SEMICOLON
     | INT ID "=" expr SEMICOLON
     | IF LPAREN expr RPAREN stmt
     | IF LPAREN expr RPAREN stmt ELSE stmt
     | WHILE LPAREN expr RPAREN stmt
     | BREAK SEMICOLON
     | CONTINUE SEMICOLON
     | RETURN expr SEMICOLON
     | RETURN SEMICOLON

block → LBRACE stmt_list RBRACE
stmt_list → stmt stmt_list | /* empty */

funcdef → (INT | VOID) ID LPAREN param_list_opt RPAREN block

param_list_opt → /* empty */ | param_list
param_list → param param_list_tail
param_list_tail → COMMA param param_list_tail | /* empty */

param → INT ID

expr → lorexpr

lorexpr → landexpr
        | lorexpr OROR landexpr

landexpr → relexpr
         | landexpr ANDAND relexpr

relexpr → addexpr
        | relexpr (LT | GT | LE | GE | EQ | NEQ) addexpr

addexpr → mulexpr
        | addexpr (PLUS | MINUS) mulexpr

mulexpr → unaryexpr
        | mulexpr (MUL | DIV | MOD) unaryexpr

unaryexpr → primaryexpr
          | (PLUS | MINUS | NOT) unaryexpr

primaryexpr → ID
            | NUMBER
            | LPAREN expr RPAREN
            | ID LPAREN expr_list_opt RPAREN

expr_list_opt → /* empty */ | expr_list
expr_list → expr expr_list_tail
expr_list_tail → COMMA expr expr_list_tail | /* empty */

```

```
%token INT VOID IF ELSE WHILE BREAK CONTINUE RETURN
%token PLUS MINUS MUL DIV MOD
%token EQ NEQ LT GT LE GE
%token ANDAND OROR NOT
%token ASSIGN        (* = *)
%token SEMICOLON     (* ; *)
%token COMMA         (* , *)
%token LPAREN RPAREN LBRACE RBRACE

%token <string> ID
%token <int> NUMBER
```

```
(* .mll 示例片段 *)
rule read_token = parse
  | [' ' '\t' '\r' '\n']     { read_token lexbuf }
  | "int"                    { INT }
  | "void"                   { VOID }
  | "if"                     { IF }
  | "else"                   { ELSE }
  | "while"                  { WHILE }
  | "break"                  { BREAK }
  | "continue"               { CONTINUE }
  | "return"                 { RETURN }

  | "+"                      { PLUS }
  | "-"                      { MINUS }
  | "*"                      { MUL }
  | "/"                      { DIV }
  | "%"                      { MOD }
  | "=="                     { EQ }
  | "!="                     { NEQ }
  | "<"                      { LT }
  | "<="                     { LE }
  | ">"                      { GT }
  | ">="                     { GE }
  | "&&"                     { ANDAND }
  | "||"                     { OROR }
  | "!"                      { NOT }

  | "="                      { ASSIGN }
  | ";"                      { SEMICOLON }
  | ","                      { COMMA }
  | "("                      { LPAREN }
  | ")"                      { RPAREN }
  | "{"                      { LBRACE }
  | "}"                      { RBRACE }

  | ['a'-'z''A'-'Z''_']['a'-'z''A'-'Z''0'-'9''_']*
                              { ID (Lexing.lexeme lexbuf) }

  | ['0'-'9']+ as num         { NUMBER (int_of_string num) }
```



# Ocaml语法分析器用到的材料

```
(* 表达式类型 *)
type expr = 
  | Num of int                        (* 整数 *)
  | Id of string                      (* 标识符 *)
  | Call of string * expr list        (* 函数调用：函数名, 参数列表 *)
  | Paren of expr                     (* 括号表达式 *)
  | UnaryOp of unary_op * expr        (* 一元表达式 *)
  | BinaryOp of binary_op * expr * expr (* 二元表达式 *)

(* 一元操作符 *)
and unary_op = 
  | Plus     (* + *)
  | Minus    (* - *)
  | Not      (* ! *) 

(* 二元操作符 *)
and binary_op = 
  | Mul | Div | Mod        (* * / % *)
  | Plus | Minus           (* + - *)
  | Lt | Gt | Le | Ge      (* < > <= >= *)
  | Eq | Neq               (* == != *)
  | AndAnd | OrOr          (* && || *)

(* 语句类型 *)
type stmt = 
  | Block of stmt list               (* 块语句: { ... } *)
  | ExprStmt of expr                 (* 表达式语句 *)
  | Assign of string * expr          (* 赋值: id = expr *)
  | Decl of param * expr             (* 变量声明: int id = expr *)
  | If of expr * stmt * stmt option  (* if语句: else分支可选 *)
  | While of expr * stmt             (* while循环 *)
  | Break                            (* break *)
  | Continue                         (* continue *)
  | Return                           (* return *)
  | EmptyStmt                        (* 空语句（用于占位） *)

(* 函数参数类型 *)
and param = 
  | Param of ty * string         (* 类型, 标识符 *)

(* 函数定义类型 *)
type funcdef = 
  | Function of ty * string * param list * stmt (* 返回类型, 函数名, 参数列表, 函数体 *)

(* 类型描述 *)
and ty = 
  | Int   (* int *)
  | Void  (* void *)

(* 编译单元（整个程序） *)
type compunit = funcdef list
```





























