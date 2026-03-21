let stack : (string * int) list ref = ref []
let push x = stack := x :: !stack

let check (input : string) =
  let rec checkinner (input : string) lst =
    match lst with
    | [] -> failwith "undefined identifier!"
    | x :: xs -> if fst x = input then snd x else checkinner input xs
  in
  checkinner input !stack
;;
