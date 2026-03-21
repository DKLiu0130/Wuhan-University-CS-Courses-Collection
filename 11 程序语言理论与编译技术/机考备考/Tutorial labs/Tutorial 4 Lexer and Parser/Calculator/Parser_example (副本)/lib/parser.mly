%{
    open Ast
%}

%token EOF ADD SUB MUL DIV LEFT RIGHT SEG ASSIGN 
%token <int> NUM
%token <string> ID
%start main
%type <Ast.term> main

%left ADD SUB
%left MUL DIV

%%
main:
    start EOF { $1 }
;

start:
    | start expression SEG { 
        let conbine x y =
        match x with 
        | Whole (a) -> Whole (a @ [y])
        | Null -> Whole ([y])
        | _ -> raise (Failure "error start!")
        in conbine $1 $2 }
    | expression SEG { Whole ([$1]) }
    | /* empty */ { Null }
;

expression:
    | ID ASSIGN NUM { Assign (Id($1, $3), Num($3)) } 
    | e { $1 }
;

e:
    | e ADD t { Add($1, $3) }
    | e SUB t { Sub($1, $3) }
    | t { $1 }
;

t:
    | t MUL f { Mul($1, $3) }
    | t DIV f { Div($1, $3) }
    | f { $1 }
;

f: 
    | ID { Id($1, 0) } 
    | LEFT e RIGHT { $2 }
;
