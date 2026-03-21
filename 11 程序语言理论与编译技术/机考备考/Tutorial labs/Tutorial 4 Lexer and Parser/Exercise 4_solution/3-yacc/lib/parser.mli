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

val main :
  (Lexing.lexbuf  -> token) -> Lexing.lexbuf -> Ast.term
