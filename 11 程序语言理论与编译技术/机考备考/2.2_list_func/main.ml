let double_num (x : int) = x * 2
let new_one = List.map double_num [ 111; 222; 333 ]

let f (num : int) =
  print_int num;
  print_char ' '
;;

List.iter f new_one;;
print_newline ()

let new_one_2 = List.filter (fun (x : int) -> x > 400) new_one;;

List.iter f new_one_2;;
print_newline ();;
List.iter f (List.rev new_one_2);;
print_newline ()

let x = List.sort compare [ 1; 3; 2; 5; 4; 7 ]
let y = List.sort (Fun.flip compare) [ 1; 3; 2; 5; 4; 7 ];;

List.iter f x;;
print_newline ();;
List.iter f y;;
print_newline ();;
print_int (List.fold_left ( + ) 0 [ 1; 3; 4; 5; 2 ]);;
print_newline ()

type correct =
  | MYTrue
  | MYFalse

let func (a : int) (b : correct) = if b = MYTrue then a + 1 else a;;

print_int (List.fold_left func 0 [ MYTrue; MYFalse; MYTrue; MYFalse; MYTrue ]);;
print_newline ()
