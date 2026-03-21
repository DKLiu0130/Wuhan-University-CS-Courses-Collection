{
    open Parser
}

rule read = parse 
    | [' ' '\t' '\n'] { read lexbuf }
    | ['0'-'9']+ as num { INT (int_of_string num) }
    | '+' { PLUS }
    | '-' { MINUS }
    | '*' { TIMES }
    | '/' { DIV }
    | "<=" { LEQ }
    | '(' { LPAREN }
    | ')' { RPAREN }
    | "if" { IF }
    | "then" { THEN }
    | "else" { ELSE }
    | "let" { LET }
    | "=" { EQUALS }
    | "in" { IN }
    | "true" { TRUE }
    | "false" { FALSE }
    | eof { EOF }
    | ['a'-'z']+ as id {ID (id) }
    | _ { failwith "Invalid character" }