(* 创建 lib/lexer.mll *)
 {
 open Parser
 }
 rule read = parse
 | [' ' '\t' '\n'] { read lexbuf } (* 跳过空白符 *)
 | ['0'-'9']+ as num { INT (int_of_string num) }
 | '+' { PLUS }
 | '-' { MINUS }
 | '*' { TIMES }
 | '/' { DIV }
 | eof { EOF }
 | _ { failwith "Unknown character" }