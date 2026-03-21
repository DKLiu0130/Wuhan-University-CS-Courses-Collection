(* 解析E *)
let rec parseE input =
  match input with
  | 'a'::rest -> parseB (parseA rest)
  | 'b'::rest -> parseB rest
  | _ -> raise (Failure "error in parseE")

(* 解析A *)
and parseA input =
  match input with
  | 'a'::rest -> parseB rest
  | 'b'::rest -> rest
  | _ -> raise (Failure "error in parseA")

(* 解析B *)
and parseB input =
  match input with
  | 'b'::rest -> parseA rest
  | 'a'::rest -> rest  
  | _ -> raise (Failure "error in parseB")

let parse input =
  try 
    let remaining = parseE input in
    if remaining = [] then "Success"
    else "Failed: Unexpected leftover input"
  with
  | Failure msg -> "Failed: " ^ msg

let test_input = ['a'; 'a'; 'a'; 'a']

let () = print_endline (parse test_input)