
{
    open Parser
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
