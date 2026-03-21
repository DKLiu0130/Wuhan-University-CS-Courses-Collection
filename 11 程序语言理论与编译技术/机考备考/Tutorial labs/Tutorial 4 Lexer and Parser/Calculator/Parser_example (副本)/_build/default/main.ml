open My_lib
open Ast

let rec print_ast ast =
  match ast with
  | Add (x, y) -> Printf.sprintf "(add %s %s)" (print_ast x) (print_ast y)
  | Sub (x, y) -> Printf.sprintf "(sub %s %s)" (print_ast x) (print_ast y)
  | Mul (x, y) -> Printf.sprintf "(mul %s %s)" (print_ast x) (print_ast y)
  | Div (x, y) -> Printf.sprintf "(div %s %s)" (print_ast x) (print_ast y)
  | Assign (x, y) -> Printf.sprintf "(assign %s %s)" (print_ast x) (print_ast y)
  | Num x -> Printf.sprintf "%s" (string_of_int x)
  | Id (x, y) -> Printf.sprintf "(Id %s %d)" x y
  | Whole x ->
    let rec print_list lst =
      match lst with
      | [] -> ""
      | h :: t -> Printf.sprintf "%s %s" (print_ast h) (print_list t)
    in
    Printf.sprintf "whole %s" (print_list x)
  | Null -> Printf.sprintf "null"
;;

let () =
  let lexbuf = Lexing.from_channel stdin in
  let ast = Parser.main Lexer.main lexbuf in
  let retstr = print_ast ast in
  Printf.printf "\n%s\n" retstr
;;
