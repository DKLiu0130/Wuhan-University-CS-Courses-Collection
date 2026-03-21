(* max in a list *)

let rec max_1 (lst : int list) =
  match lst with
  | [] -> failwith "wrong"
  | [ x ] -> x
  | x :: y -> max x (max_1 y)
;;

let max_2 (lst : int list) =
  match lst with
  | [] -> failwith "wrong"
  | x :: y ->
    let rec max_inner lst (num : int) =
      match lst with
      | x :: y -> if x > num then max_inner y x else max_inner y num
      | _ -> num
    in
    max_inner lst x
;;

print_int (max_1 [ 1; 3; 2; 4; 0 ]);;
print_newline ();;
print_int (max_2 [ 2; 4; 9; 1; 4; 5 ])
