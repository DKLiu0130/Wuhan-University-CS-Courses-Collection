let diff (x : int list) =
  let rec diff_inner x lst =
    match x with
    | x :: y :: t -> diff_inner ([ y ] @ t) (List.append lst [ y - x ])
    | _ -> lst
  in
  diff_inner x []
;;

let lst = diff [ 1; 2; -1; 4; 2 ]
let f x = print_endline (string_of_int x);;

List.iter f lst
