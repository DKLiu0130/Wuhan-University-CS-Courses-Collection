(* 表达式的递归变体定义 *)
type expr =
  | Const of int
  | Add of expr * expr
  | Sub of expr * expr
  | Mul of expr * expr
  | Div of expr * expr

(* 计算表达式的值
  - 如果表达式包含除以零的情况，则返回 None
  - 否则返回 Some 计算结果
*)
let rec evaluate (expr : expr) : int option =
  (* 递归计算表达式的值 *)
  match expr with
  | Const n -> Some n
  | Add (e1, e2) -> (
      match evaluate e1, evaluate e2 with
      | Some v1, Some v2 -> Some (v1 + v2)
      | _ -> None
    )
  | Sub (e1, e2) -> (
      match evaluate e1, evaluate e2 with
      | Some v1, Some v2 -> Some (v1 - v2)
      | _ -> None
    )
  | Mul (e1, e2) -> (
      match evaluate e1, evaluate e2 with
      | Some v1, Some v2 -> Some (v1 * v2)
      | _ -> None
    )
  | Div (e1, e2) -> (
      match evaluate e1, evaluate e2 with
      | Some v1, Some v2 -> if v2 = 0 then None else Some (v1 / v2)
      | _ -> None
    )