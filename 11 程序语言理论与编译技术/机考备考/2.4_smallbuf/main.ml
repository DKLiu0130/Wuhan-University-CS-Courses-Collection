let string_to_char_list str = String.fold_right (fun c acc -> c :: acc) str []

let rec rotate_left lst n =
  if n <= 0
  then lst
  else (
    match lst with
    | [] -> []
    | hd :: tl -> rotate_left (tl @ [ hd ]) (n - 1))
;;

let rotate_right lst n =
  let len = List.length lst in
  let n = n mod len in
  rotate_left lst (len - n)
;;

let rec smallbf_helper mem cmd offset =
  match mem with
  | [] -> failwith "wrong"
  | curr_mem :: rest_mem ->
    (match cmd with
     | [] -> rotate_right (curr_mem :: rest_mem) offset
     | '+' :: rest -> smallbf_helper ((curr_mem + 1) :: rest_mem) rest offset
     | '>' :: rest -> smallbf_helper (rest_mem @ [ curr_mem ]) rest (offset + 1)
     | _ -> failwith "wrong")
;;

let smallbf mem cmd_as_str = smallbf_helper mem (string_to_char_list cmd_as_str) 0
let x = smallbf [ 2; 0; 1 ] "++>>+>++"

let f num =
  print_int num;
  print_newline ()
;;

List.iter f x
