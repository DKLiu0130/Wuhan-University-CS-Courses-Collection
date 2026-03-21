{
    open Parser
}

rule read = parse 
    | [' ' '\t' '\n'] { read lexbuf }
    | '+' { PLUS }
    | '-' { MINUS }
    | '*' { TIMES }
    | '/' { DIV }
    | '(' { LPAREN }
    | ')' { RPAREN }
    | "<=" { LEQ }
    | "true" { TRUE }
    | "false" { FALSE }
    | "let" { LET }
    | "=" { EQUALS }
    | "in" { IN }
    | "if" { IF }
    | "then" { THEN }
    | "else" { ELSE }
    | "->" { ARROW }
    | "fun" { FUNC }
    | ['0'-'9']+ as num { INT (int_of_string num) }
    | ['a'-'z' 'A'-'Z']+ as id { ID id }
    | eof { EOF }
    | _ { failwith "Invalid character" }