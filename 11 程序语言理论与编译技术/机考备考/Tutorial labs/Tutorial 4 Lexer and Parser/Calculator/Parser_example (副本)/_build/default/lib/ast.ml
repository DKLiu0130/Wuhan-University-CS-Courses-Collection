type term =
  | Add of term * term
  | Sub of term * term
  | Mul of term * term
  | Div of term * term
  | Assign of term * term
  | Num of int
  | Id of string * int
  | Whole of term list
  | Null
