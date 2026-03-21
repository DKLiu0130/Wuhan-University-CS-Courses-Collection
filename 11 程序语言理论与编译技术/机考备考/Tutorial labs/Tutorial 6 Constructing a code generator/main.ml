open Simpl_riscv
open Ast

let rec string_of_expr (e : expr) : string = 
  match e with
  | Int n -> Printf.sprintf "Int %d" n
  | Var id -> Printf.sprintf "Var %s" id
  | Bool b -> 
    let b_str = 
      match b with 
      | true -> "true"
      | false -> "false"
    in
    Printf.sprintf "Bool %s" b_str
  | Binop (binop, e1, e2) ->
    let binop_str = 
      match binop with 
      | Add -> "Add"
      | Mul -> "Mul"
      | Sub -> "Sub"
      | Div -> "Div"
      | Leq -> "Leq"
    in
    Printf.sprintf "Binop (%s, %s, %s)" binop_str (string_of_expr e1) (string_of_expr e2)
  | Let (var, e1, e2) -> Printf.sprintf "Let (%s, %s, %s)" var (string_of_expr e1) (string_of_expr e2)
  | If (e1, e2, e3) -> Printf.sprintf "If (%s, %s, %s)" (string_of_expr e1) (string_of_expr e2) (string_of_expr e3)
  | Func (var, e) -> Printf.sprintf "Func (%s, %s)" var (string_of_expr e)
  | App (e1, e2) -> Printf.sprintf "App (%s, %s)" (string_of_expr e1) (string_of_expr e2)

let parse s : expr =
  let lexbuf = Lexing.from_string s in
  let ast = Parser.main Lexer.read lexbuf in
  ast


(* 全局标签计数器，用于生成唯一标签 *)
let label_count = ref 0
let fresh_label prefix = 
  incr label_count;
  Printf.sprintf "%s_%d" prefix !label_count

(* 全局列表：保存所有生成的函数代码，最终附加在程序末尾 *)
let functions : string list ref = ref []

(* 简单的自由变量分析（不去重，仅适用于教学示例） *)
let rec free_vars expr bound = 
  match expr with
  | Int _ | Bool _ -> []
  | Var x -> if List.mem x bound then [] else [x]
  | Binop (_, e1, e2) -> free_vars e1 bound @ free_vars e2 bound
  | Let (x, e1, e2) -> free_vars e1 bound @ free_vars e2 (x :: bound)
  | If (cond, e_then, e_else) ->
    free_vars cond bound @ free_vars e_then bound @ free_vars e_else bound
  | Func (x, body) -> free_vars body (x :: bound)
  | App (e1, e2) -> free_vars e1 bound @ free_vars e2 bound

(*
  compile_expr env cur_offset expr
  env: (variable, offset) 的关联列表，其中 offset 是相对于 fp 的偏移（单位：字节）
  cur_offset: 当前已经分配的 let 变量字节数（每个变量占 8 字节）
  返回的汇编代码保证计算结果存放在寄存器 a0 中
*)
let rec compiler_expr (env : (string * int) list) (cur_offset : int) (expr : expr) : string = 
  match expr with
  | Int n -> 
    Printf.sprintf "\tli a0, %d\n" n
  | Bool b ->
    if b then "\tli a0, 1\n" else "\tli a0, 0\n"
  | Var x ->
    (try
      let offset = List.assoc x env in
      Printf.sprintf "\tld a0, -%d(fp)\n" offset
    with Not_found ->
      failwith ("Unbound variable: " ^ x))
  (* Task starts here *)
  | _ -> failwith "TODO"
    

and compile_expr_func (local_env : (string * int) list) (closure_env : (string * int) list) (cur_offset : int) (expr : expr) : string =
  match expr with
  | _ -> failwith "TODO"

let compiler_program (e : expr) : string =
  let body_code = compiler_expr [] 0 e in
  let prologue = 
    ".text\n\
    .global main\n\
    main:\n\
    \taddi sp, sp, -64\n\
    \tmv fp, sp\n"
  in
  let epilogue = 
    "\
    \tmv sp, fp\n\
    \taddi sp, sp, 64\n\
    \tret\n"
  in
  let func_code = String.concat "\n" !functions in
  prologue ^ body_code ^ epilogue ^ "\n" ^ func_code
  
let () =
  let filename = "test.in" in
  (* let filename = "test/simpl_test2.in" in *)
  let in_channel = open_in filename in
  let file_content = really_input_string in_channel (in_channel_length in_channel) in
  close_in in_channel;

  (* let res = interp file_content in
  Printf.printf "Result of interpreting %s:\n%s\n\n" filename res;

  let res = interp_big file_content in
  Printf.printf "Result of interpreting %s with big-step model:\n%s\n\n" filename res; *)

  let ast = parse file_content in 
  Printf.printf "AST: %s\n" (string_of_expr ast);

  let output_file = Sys.argv.(1) in
  let oc = open_out output_file in

  let asm_code = compiler_program ast in

  output_string oc asm_code;
  close_out oc;
  Printf.printf "Generated RISC-V code saved to: %s\n" output_file