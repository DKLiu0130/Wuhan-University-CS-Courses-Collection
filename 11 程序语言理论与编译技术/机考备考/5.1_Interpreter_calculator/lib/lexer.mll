{
    open Parser
}

(* 规则定义 *)
rule read = parse 
    | [' ' '\t' '\n'] { read lexbuf }
    | ['0'-'9']+ as num { INT (int_of_string num) }
    | '+' { PLUS }
    | '-' { MINUS }
    | '*' { TIMES }
    | '/' { DIV }
    | '(' { LPAREN }
    | ')' { RPAREN }
    | eof { EOF }
    | _ { failwith "Invalid character" }