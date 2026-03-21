type token =
  | EOF
  | ADD
  | SUB
  | MUL
  | DIV
  | LEFT
  | RIGHT
  | SEG
  | ASSIGN
  | NUM of (int)
  | ID of (string)

val main :
  (Lexing.lexbuf  -> token) -> Lexing.lexbuf -> Ast.term
