{
open Token
}

rule main = parse
  | [' ' '\t' '\n']+ { main lexbuf } 

  | "true"          { TRUE }
  | "false"         { FALSE }
  | "if"            { IF }
  | "then"          { THEN }
  | "else"          { ELSE }
  | "0"             { ZERO }
  | "succ"          { SUCC }
  | "pred"          { PRED }
  | "iszero"        { ISZERO }

  | eof             { EOF }

  | _               { failwith "Unrecognized token" }