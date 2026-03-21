type binop = 
  | Add
  | Sub
  | Mul
  | Div
  | Leq

type expr =
  | Int of int
  | Var of string
  | Bool of bool
  | Binop of binop * expr * expr
  | Let of string * expr * expr
  | If of expr * expr * expr
