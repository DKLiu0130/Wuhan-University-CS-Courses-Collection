 (* 创建 main.ml *)
 open Lex_project
 open Ast
 let rec string_of_expr = function
 | Num n -> string_of_int n
 | Add (e1, e2) -> Printf.sprintf "(%s + %s)" (string_of_expr e1) 
(string_of_expr e2)
 | Sub (e1, e2) -> Printf.sprintf "(%s - %s)" (string_of_expr e1) 
(string_of_expr e2)
 | Mul (e1, e2) -> Printf.sprintf "(%s * %s)" (string_of_expr e1) 
(string_of_expr e2)
 | Div (e1, e2) -> Printf.sprintf "(%s / %s)" (string_of_expr e1) 
(string_of_expr e2)
 let () =
 let lexbuf = Lexing.from_channel stdin in
 let ast = Parser.main Lexer.read lexbuf in
 Printf.printf "\nAST: %s\n" (string_of_expr ast)