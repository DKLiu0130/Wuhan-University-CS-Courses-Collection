
(* The type of tokens. *)

type token = 
  | TRUE
  | TIMES
  | THEN
  | RPAREN
  | PLUS
  | MINUS
  | LPAREN
  | LET
  | LEQ
  | INT of (int)
  | IN
  | IF
  | ID of (string)
  | FUNC
  | FALSE
  | EQUALS
  | EOF
  | ELSE
  | DIV
  | ARROW

(* This exception is raised by the monolithic API functions. *)

exception Error

(* The monolithic API. *)

val main: (Lexing.lexbuf -> token) -> Lexing.lexbuf -> (Ast.expr)
