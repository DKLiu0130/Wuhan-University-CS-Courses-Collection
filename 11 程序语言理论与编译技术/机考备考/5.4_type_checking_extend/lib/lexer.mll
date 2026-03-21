{
    open Parser
}

rule read = parse 
    | [' ' '\t']     { read lexbuf }
    | '\n'           {
        (* 告诉 lexbuf：换行了 用于调试 *)
        let pos = lexbuf.lex_curr_p in (* pos 指向 \n 的下一个位置 *)
        let new_pos = { pos with
            Lexing.pos_lnum = pos.Lexing.pos_lnum + 1;
            Lexing.pos_bol = pos.Lexing.pos_cnum;
        } in
        lexbuf.lex_curr_p <- new_pos;
        read lexbuf
        }
    | ['0'-'9']+ as num { INT (int_of_string num) }
    | '+' { PLUS }
    | '-' { MINUS }
    | '*' { TIMES }
    | '/' { DIV }
    | "<=" { LEQ }
    | "<" { LESS }
    | ">" { GREATER }
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
    | ";" { SEMICOLON }
    | "==" { EQUAL }
    | "!=" { NOTEQUAL }
    | "&&" { LAND }
    | "||" { LOR }
    | '!' { NOT }
    | eof { EOF }
    | ['a'-'z' 'A'-'Z' '_']['a'-'z' 'A'-'Z' '0'-'9' '_']* as id { ID id }

    | _ { failwith "Invalid character" }