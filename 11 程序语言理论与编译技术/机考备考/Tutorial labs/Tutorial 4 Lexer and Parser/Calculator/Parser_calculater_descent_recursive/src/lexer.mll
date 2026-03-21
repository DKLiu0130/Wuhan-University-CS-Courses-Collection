{
    open Token

}

rule main = parse
| ['a'-'z']+ as str { ID (str) }
| ['0'-'9']+ as num { NUM (int_of_string num) }
| [' ' '\n' '\t'] { main lexbuf }
| "+" { ADD }
| "-" { SUB }
| "*" { MUL }
| "/" { DIV }
| "(" { LEFT }
| ")" { RIGHT }
| "=" { ASSIGN }
| ";" { SEG }
| eof { EOF }
| _ { failwith "error in lexing" }


{

(* let string_of_token2 tok =
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

let rec gettokens (lst : token list) lexbuf =
    let token = main lexbuf in
    match token with
    | EOF -> (* Printf.printf "%s\n" (string_of_token2 token);*) lst  
    | _ -> (* Printf.printf "%s\n" (string_of_token2 token);*) gettokens (lst @ [token]) lexbuf 
;;
 
}
