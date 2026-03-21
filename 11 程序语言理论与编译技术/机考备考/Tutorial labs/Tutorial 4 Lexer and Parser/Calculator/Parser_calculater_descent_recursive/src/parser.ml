open Ast
open Token

(*let string_of_token tok =
  match tok with
  | EOF -> "eof"
  | ID _ -> "id"
  | NUM _ -> "num"
  | ADD -> "add"
  | SUB -> "sub"
  | MUL -> "mul"
  | DIV -> "div"
  | LEFT -> "left"
  | RIGHT -> "right"
  | SEG -> "seg"
  | ASSIGN -> "assign"
;;  *)

let rec start_state lst ast =
  match lst with
  | ID _ :: _ | LEFT :: _ ->
    (* print_string "here1!"; *)
    let lst, ast = expression_state lst in
    (match lst with
     | SEG :: t ->
       (* print_string "here2!"; *)
       let lsti, asti = start_state t ast in
       (match asti with
        | Whole x -> lsti, Whole (ast :: x)
        | x -> lsti, Whole [ x ])
     | _ -> raise (Failure "error start_state!"))
  | [] -> lst, ast
  | _ -> raise (Failure "error start_state!")

and expression_state lst =
  match lst with
  | ID x :: y ->
    (match y with
     | ASSIGN :: rs ->
       (match rs with
        | NUM num :: rest_list ->
          Stack.push (x, num);
          rest_list, Assign (Id x, Num num)
        | _ -> raise (Failure "error expression_state1!"))
     | MUL :: _ | DIV :: _ | ADD :: _ | SUB :: _ | SEG :: _ | RIGHT :: _ -> e_state lst
     | [] -> raise (Failure "error expression_state4!")
     | _ ->
       (* print_string (string_of_token h); *)
       raise (Failure "error expression_state2!"))
  | LEFT :: _ -> e_state lst
  | _ -> raise (Failure "error expression_state3!")

and e_state lst =
  match lst with
  | ID _ :: _ | LEFT :: _ ->
    let retlst, ast = t_state lst in
    e1_state retlst ast
  | _ -> raise (Failure "error e_state!")

and e1_state lst ast =
  match lst with
  | ADD :: t ->
    let retlst1, ast1 = t_state t in
    e1_state retlst1 (Add (ast, ast1))
  | SUB :: t ->
    let retlst1, ast1 = t_state t in
    e1_state retlst1 (Sub (ast, ast1))
  | RIGHT :: _ | SEG :: _ | [] -> lst, ast
  | _ -> raise (Failure "error e1_state!")

and t_state lst =
  match lst with
  | ID _ :: _ | LEFT :: _ ->
    let retlst1, ast1 = f_state lst in
    t1_state retlst1 ast1
  | _ -> raise (Failure "error t_state!")

and t1_state lst ast =
  match lst with
  | MUL :: t ->
    let retlst1, ast1 = f_state t in
    t1_state retlst1 (Mul (ast, ast1))
  | DIV :: t ->
    let retlst1, ast1 = f_state t in
    t1_state retlst1 (Div (ast, ast1))
  | RIGHT :: _ | SEG :: _ | [] | ADD :: _ | SUB :: _ -> lst, ast
  | _ -> raise (Failure "error t1_state!")

and f_state lst =
  match lst with
  | ID x :: t -> t, Id x
  | LEFT :: t ->
    let retlst, ast1 = e_state t in
    (match retlst with
     | RIGHT :: t -> t, ast1
     | _ -> raise (Failure "error f_state!"))
  | _ -> raise (Failure "error f_state!")
;;

let main_state lst =
  match lst with
  | ID _ :: _ ->
    let lst, ast = start_state lst Null in
    (match lst with
     | [] -> ast
     | _ -> raise (Failure "error main_state!"))
  | [] | LEFT :: _ ->
    let lst, ast = start_state lst Null in
    (match lst with
     | [] -> ast
     | _ -> raise (Failure "error main_state!"))
  | _ -> raise (Failure "error main_state!")
;;
