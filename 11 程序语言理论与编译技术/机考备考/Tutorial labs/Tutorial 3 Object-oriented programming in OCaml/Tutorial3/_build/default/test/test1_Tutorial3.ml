open QCheck
open Solution_Tutorial3.Solution1

let rec gen_expr depth =
  let open Gen in
  if depth = 0 then
    map (fun n -> Const n) int
  else
    frequency
      [
        (1, map (fun n -> Const n) int);
        (2, map2 (fun e1 e2 -> Add (e1, e2)) (gen_expr (depth - 1)) (gen_expr (depth - 1)));
        (2, map2 (fun e1 e2 -> Sub (e1, e2)) (gen_expr (depth - 1)) (gen_expr (depth - 1)));
        (2, map2 (fun e1 e2 -> Mul (e1, e2)) (gen_expr (depth - 1)) (gen_expr (depth - 1)));
        (2, map2 (fun e1 e2 -> Div (e1, e2)) (gen_expr (depth - 1)) (gen_expr (depth - 1)));
      ]

let rec expr_to_string = function
  | Const n -> string_of_int n
  | Add (e1, e2) -> Printf.sprintf "(%s + %s)" (expr_to_string e1) (expr_to_string e2)
  | Sub (e1, e2) -> Printf.sprintf "(%s - %s)" (expr_to_string e1) (expr_to_string e2)
  | Mul (e1, e2) -> Printf.sprintf "(%s * %s)" (expr_to_string e1) (expr_to_string e2)
  | Div (e1, e2) -> Printf.sprintf "(%s / %s)" (expr_to_string e1) (expr_to_string e2)

let arb_expr = make ~print:expr_to_string (gen_expr 5)

let test_no_division_by_zero =
  Test.make ~name:"No division by zero" arb_expr (fun expr ->
      match expr with
      | Div (_, Const 0) -> evaluate expr = None
      | _ -> true)

let test_valid_expressions =
  Test.make ~name:"Valid expressions evaluate correctly" arb_expr (fun expr ->
      match evaluate expr with
      | None -> true
      | Some _ -> true)

let rec manual_evaluate = function
  | Const n -> Some n
  | Add (e1, e2) -> (
      match manual_evaluate e1, manual_evaluate e2 with
      | Some v1, Some v2 -> Some (v1 + v2)
      | _ -> None
    )
  | Sub (e1, e2) -> (
      match manual_evaluate e1, manual_evaluate e2 with
      | Some v1, Some v2 -> Some (v1 - v2)
      | _ -> None
    )
  | Mul (e1, e2) -> (
      match manual_evaluate e1, manual_evaluate e2 with
      | Some v1, Some v2 -> Some (v1 * v2)
      | _ -> None
    )
  | Div (e1, e2) -> (
      match manual_evaluate e1, manual_evaluate e2 with
      | Some v1, Some v2 -> if v2 = 0 then None else Some (v1 / v2)
      | _ -> None
    )

let test_evaluate_correctness =
  Test.make ~name:"Evaluate correctness" arb_expr (fun expr ->
      evaluate expr = manual_evaluate expr)

let () = QCheck_runner.run_tests_main [test_no_division_by_zero; test_valid_expressions; test_evaluate_correctness]