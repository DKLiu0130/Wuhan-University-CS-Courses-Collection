 (* 创建 lib/ast.ml *)
 type expr =
 | Num of int
 | Add of expr * expr
 | Sub of expr * expr
 | Mul of expr * expr
 | Div of expr * expr