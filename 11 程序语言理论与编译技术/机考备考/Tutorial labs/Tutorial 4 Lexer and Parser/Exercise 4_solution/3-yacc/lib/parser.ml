type token =
  | TRUE
  | FALSE
  | IF
  | THEN
  | ELSE
  | ZERO
  | SUCC
  | PRED
  | ISZERO
  | EOF

open Parsing;;
let _ = parse_error;;
# 2 "lib/parser.mly"
  open Ast
# 18 "lib/parser.ml"
let yytransl_const = [|
  257 (* TRUE *);
  258 (* FALSE *);
  259 (* IF *);
  260 (* THEN *);
  261 (* ELSE *);
  262 (* ZERO *);
  263 (* SUCC *);
  264 (* PRED *);
  265 (* ISZERO *);
    0 (* EOF *);
    0|]

let yytransl_block = [|
    0|]

let yylhs = "\255\255\
\001\000\002\000\002\000\002\000\002\000\002\000\002\000\002\000\
\000\000"

let yylen = "\002\000\
\002\000\001\000\001\000\001\000\002\000\002\000\002\000\006\000\
\002\000"

let yydefred = "\000\000\
\000\000\000\000\002\000\003\000\000\000\004\000\000\000\000\000\
\000\000\009\000\000\000\000\000\005\000\006\000\007\000\001\000\
\000\000\000\000\000\000\008\000"

let yydgoto = "\002\000\
\010\000\011\000"

let yysindex = "\004\000\
\014\255\000\000\000\000\000\000\014\255\000\000\014\255\014\255\
\014\255\000\000\001\000\002\255\000\000\000\000\000\000\000\000\
\014\255\003\255\014\255\000\000"

let yyrindex = "\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000"

let yygindex = "\000\000\
\000\000\251\255"

let yytablesize = 23
let yytable = "\012\000\
\016\000\013\000\014\000\015\000\001\000\017\000\000\000\019\000\
\000\000\000\000\000\000\018\000\000\000\020\000\003\000\004\000\
\005\000\000\000\000\000\006\000\007\000\008\000\009\000"

let yycheck = "\005\000\
\000\000\007\000\008\000\009\000\001\000\004\001\255\255\005\001\
\255\255\255\255\255\255\017\000\255\255\019\000\001\001\002\001\
\003\001\255\255\255\255\006\001\007\001\008\001\009\001"

let yynames_const = "\
  TRUE\000\
  FALSE\000\
  IF\000\
  THEN\000\
  ELSE\000\
  ZERO\000\
  SUCC\000\
  PRED\000\
  ISZERO\000\
  EOF\000\
  "

let yynames_block = "\
  "

let yyact = [|
  (fun _ -> failwith "parser")
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : 'term) in
    Obj.repr(
# 12 "lib/parser.mly"
           ( _1 )
# 98 "lib/parser.ml"
               : Ast.term))
; (fun __caml_parser_env ->
    Obj.repr(
# 17 "lib/parser.mly"
                 ( True )
# 104 "lib/parser.ml"
               : 'term))
; (fun __caml_parser_env ->
    Obj.repr(
# 18 "lib/parser.mly"
                 ( False )
# 110 "lib/parser.ml"
               : 'term))
; (fun __caml_parser_env ->
    Obj.repr(
# 19 "lib/parser.mly"
                 ( Zero )
# 116 "lib/parser.ml"
               : 'term))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 0 : 'term) in
    Obj.repr(
# 20 "lib/parser.mly"
                 ( Succ(_2) )
# 123 "lib/parser.ml"
               : 'term))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 0 : 'term) in
    Obj.repr(
# 21 "lib/parser.mly"
                 ( Pred(_2) )
# 130 "lib/parser.ml"
               : 'term))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 0 : 'term) in
    Obj.repr(
# 22 "lib/parser.mly"
                 ( IsZero(_2) )
# 137 "lib/parser.ml"
               : 'term))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 4 : 'term) in
    let _4 = (Parsing.peek_val __caml_parser_env 2 : 'term) in
    let _6 = (Parsing.peek_val __caml_parser_env 0 : 'term) in
    Obj.repr(
# 23 "lib/parser.mly"
                              ( If(_2, _4, _6) )
# 146 "lib/parser.ml"
               : 'term))
(* Entry main *)
; (fun __caml_parser_env -> raise (Parsing.YYexit (Parsing.peek_val __caml_parser_env 0)))
|]
let yytables =
  { Parsing.actions=yyact;
    Parsing.transl_const=yytransl_const;
    Parsing.transl_block=yytransl_block;
    Parsing.lhs=yylhs;
    Parsing.len=yylen;
    Parsing.defred=yydefred;
    Parsing.dgoto=yydgoto;
    Parsing.sindex=yysindex;
    Parsing.rindex=yyrindex;
    Parsing.gindex=yygindex;
    Parsing.tablesize=yytablesize;
    Parsing.table=yytable;
    Parsing.check=yycheck;
    Parsing.error_function=parse_error;
    Parsing.names_const=yynames_const;
    Parsing.names_block=yynames_block }
let main (lexfun : Lexing.lexbuf -> token) (lexbuf : Lexing.lexbuf) =
   (Parsing.yyparse yytables 1 lexfun lexbuf : Ast.term)
