type binop = 
  | Add
  | Sub
  | Mul
  | Div
  | Leq

type expr =
  | Int of int
  | Bool of bool
  | Var of string
  | Binop of binop * expr * expr
  | If of expr * expr * expr
  | Let of string * expr * expr

type typ = 
  | TInt
  | TBool
