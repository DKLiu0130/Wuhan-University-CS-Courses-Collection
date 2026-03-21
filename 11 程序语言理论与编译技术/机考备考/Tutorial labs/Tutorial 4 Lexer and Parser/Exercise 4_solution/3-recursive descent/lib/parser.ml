open Ast
open Token

let next_token lexbuf = Lexer.main lexbuf

let string_of_token = function
  | TRUE -> "TRUE"
  | FALSE -> "FALSE"
  | ZERO -> "ZERO"
  | SUCC -> "SUCC"
  | PRED -> "PRED"
  | ISZERO -> "ISZERO"
  | IF -> "IF"
  | THEN -> "THEN"
  | ELSE -> "ELSE"
  | EOF -> "EOF"

let expect token lexbuf =
  let current = next_token lexbuf in
  if current <> token then
    failwith (Printf.sprintf "\nUnexpected token: %s" (string_of_token token))

let rec parseTerm lexbuf =
  match next_token lexbuf with
  | TRUE -> True
  | FALSE -> False
  | ZERO -> Zero
  | SUCC ->
      let t = parseTerm lexbuf in
      Succ t
  | PRED ->
      let t = parseTerm lexbuf in
      Pred t
  | ISZERO ->
      let t = parseTerm lexbuf in
      IsZero t
  | IF ->
      let cond = parseTerm lexbuf in
      expect THEN lexbuf;
      let t1 = parseTerm lexbuf in
      expect ELSE lexbuf;
      let t2 = parseTerm lexbuf in
      If (cond, t1, t2)
  | token ->
      failwith (Printf.sprintf "\nUnexpected token: %s" (string_of_token token))

let parse lexbuf =
  let ast = parseTerm lexbuf in
  match next_token lexbuf with
  | EOF -> ast
  | token ->
      failwith (Printf.sprintf "\nUnexpected token %s after parsing" (string_of_token token))