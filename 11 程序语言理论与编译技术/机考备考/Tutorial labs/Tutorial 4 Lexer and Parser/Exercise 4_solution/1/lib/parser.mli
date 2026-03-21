type token =
  | INT of (int)
  | PLUS
  | MINUS
  | TIMES
  | DIV
  | EOF

val main :
  (Lexing.lexbuf  -> token) -> Lexing.lexbuf -> Ast.expr
