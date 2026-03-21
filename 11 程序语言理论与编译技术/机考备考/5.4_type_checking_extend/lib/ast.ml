type binop = 
  | Add
  | Sub
  | Mul
  | Div
  | Leq
  | Eq
  | Neq
  | Less
  | Greater
  | Land (* 指的是 && *)
  | Lor (* 指的是 || *)

type unop = 
  | Not (* 指的是 ! *)
  | Minus (* 指的是 - *)

type expr =
  | Int of int
  | Bool of bool
  | Var of string
  | Binop of binop * expr * expr
  | Unop of unop * expr
  | If of expr * expr * expr
  | Let of string * expr * expr

type typ = 
  | TInt
  | TBool

(* stmt 由 expr 的列表生成 *)
type stmt =
  | StmtList of expr list
