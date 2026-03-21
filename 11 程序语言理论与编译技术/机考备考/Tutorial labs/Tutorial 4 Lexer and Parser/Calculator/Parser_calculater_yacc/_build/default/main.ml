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
  | Id x -> Printf.sprintf "(Id %s)" x
  | Whole x ->
    let rec print_list lst =
      match lst with
      | [] -> ""
      | h :: t -> Printf.sprintf "%s %s" (print_ast h) (print_list t)
    in
    Printf.sprintf "whole %s" (print_list x)
  | Null -> Printf.sprintf "null"
;;

let rec calculate_num ast =
  match ast with
  | Add (x, y) -> calculate_num x + calculate_num y
  | Sub (x, y) -> calculate_num x - calculate_num y
  | Mul (x, y) -> calculate_num x * calculate_num y
  | Div (x, y) -> calculate_num x / calculate_num y
  | Id x -> Stack.check x
  | _ -> raise (Failure "error in calculate_num")
;;

let calculate_print ast =
  match ast with
  | Whole lst ->
    let rec func list =
      match list with
      | [] -> ()
      | h :: t ->
        (match h with
         | Assign _ -> func t
         | _ ->
           Printf.printf "\nRESULT: %d\n" (calculate_num h);
           func t)
    in
    func lst
  | _ -> raise (Failure "error calculate_print")
;;

let () =
  let lexbuf = Lexing.from_channel stdin in
  let ast = Parser.main Lexer.main lexbuf in
  let retstr = print_ast ast in
  Printf.printf "\n%s\n" retstr;
  calculate_print ast
;;
