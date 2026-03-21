type binop = 
  | Add
  | Sub
  | Mul
  | Div

type expr =
  | Int of int
  | Binop of binop * expr * expr
