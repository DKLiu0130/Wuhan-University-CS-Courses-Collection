let rec forall (p : 'a -> bool) (lst : 'a list) =
  match lst with
  | x :: y -> if p x = true then forall p y else false
  | _ -> true
;;

let is_positive (num : int) = num > 0

let () =
  if forall is_positive [ 1; 3; 5; 7; -1 ]
  then print_endline "all true"
  else print_endline "not all true"
;;
