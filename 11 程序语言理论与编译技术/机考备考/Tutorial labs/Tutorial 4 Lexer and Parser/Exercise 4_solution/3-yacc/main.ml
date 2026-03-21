open Lex_project
open Ast

let rec string_of_term = function
  | True -> "true"
  | False -> "false"
  | Zero -> "0"
  | Succ t -> Printf.sprintf "succ(%s)" (string_of_term t)
  | Pred t -> Printf.sprintf "pred(%s)" (string_of_term t)
  | IsZero t -> Printf.sprintf "iszero(%s)" (string_of_term t)
  | If (cond, t1, t2) ->
      Printf.sprintf "(if %s then %s else %s)"
        (string_of_term cond)
        (string_of_term t1)
        (string_of_term t2)

let () =
  try
    let lexbuf = Lexing.from_channel stdin in
    let ast = Parser.main Lexer.main lexbuf in
    Printf.printf "\nAST: %s\n" (string_of_term ast)
  with
  | Failure msg ->
    Printf.eprintf "Error: %s\n" msg