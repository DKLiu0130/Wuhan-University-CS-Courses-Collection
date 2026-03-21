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

(* 虚拟寄存器计数器，用于分配新的虚拟寄存器 *)
let vreg_count = ref 0
let fresh_vreg () = 
  incr vreg_count;
  !vreg_count

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

(* 常量折叠函数 *)
let eval_const_expr e =
  match e with

  (* TODO: 
   *
   * task1 补全常量折叠函数 
   * 
   *)

  | _ -> None


(* 检查一个整数是否为2的幂 *)
let is_power_of_two n =
  n > 0 && (n land (n-1)) = 0

(* 计算一个2的幂数的幂次 *)
let log2 n =
  let rec aux i n =
    if n = 1 then i
    else aux (i+1) (n/2)
  in
  if is_power_of_two n then aux 0 n
  else failwith "Not a power of 2"

(* 代码生成函数现在返回 (代码, 结果寄存器) 对 *)
let rec compiler_expr (env : (string * int) list) (expr : expr) : string * int = 
  match eval_const_expr expr with
  | Some (Int n) -> 
      let result_reg = fresh_vreg () in
      Printf.sprintf "\tli a%d, %d\n" result_reg n, result_reg
  | _ ->
      match expr with
      | Int n -> 
          let result_reg = fresh_vreg () in
          Printf.sprintf "\tli a%d, %d\n" result_reg n, result_reg
      | Bool b ->
          let result_reg = fresh_vreg () in
          Printf.sprintf "\tli a%d, %d\n" result_reg (if b then 1 else 0), result_reg
      | Var x ->
          (try
            let reg = List.assoc x env in
            "", reg  
          with Not_found ->
            failwith ("Unbound variable: " ^ x))
      | Binop (op, e1, e2) ->
          (match op with
          | Add ->
             (* TODO:
              * 
              * task2: 加法操作优化
              * 1. 识别 a + (b * c) 模式，使用乘加指令 madd
              * 2. 识别 a + 常量 模式，使用立即数加法 addi
              * 3. 一般情况下的加法
              *
              *)
          | Mul ->
             (* TODO:
              *
              * task3: 乘法操作优化
              * 1. 识别 a * 2^n 模式，使用左移指令 slli
              * 2. 识别 2^n * a 模式，使用左移指令 slli
              * 3. 识别两个常数相乘，直接计算结果
              * 4. 一般乘法
              *
              *)
          | Sub ->
             (* TODO:
              *
              * task4: 减法操作优化
              * 1. 识别 a - 常量 模式，使用负数立即数加法
              * 2. 一般减法
              *
              *)
          | Div ->
              (* 除法 *)
              let code1, reg1 = compiler_expr env e1 in
              let code2, reg2 = compiler_expr env e2 in
              let result_reg = fresh_vreg () in
              code1 ^ code2 ^ Printf.sprintf "\tdiv a%d, a%d, a%d\n" result_reg reg1 reg2, result_reg
          | Leq ->
              (* 小于等于比较 *)
              let code1, reg1 = compiler_expr env e1 in
              let code2, reg2 = compiler_expr env e2 in
              let result_reg = fresh_vreg () in
              code1 ^ code2 ^ 
              Printf.sprintf "\tsgt a%d, a%d, a%d\n\txori a%d, a%d, 1\n" 
                  result_reg reg1 reg2 result_reg result_reg, 
              result_reg)
      | Let (x, e1, e2) ->
          let code1, reg1 = compiler_expr env e1 in
          let env' = (x, reg1) :: env in
          let code2, reg2 = compiler_expr env' e2 in
          code1 ^ code2, reg2
      | If (cond, e_then, e_else) ->
          let code_cond, reg_cond = compiler_expr env cond in
          let code_then, reg_then = compiler_expr env e_then in
          let code_else, reg_else = compiler_expr env e_else in
          
          let result_reg = fresh_vreg () in
          let label_else = fresh_label "Lelse" in
          let label_end = fresh_label "Lend" in
          
          let code = 
            code_cond ^
            Printf.sprintf "\tbeq a%d, x0, %s\n" reg_cond label_else ^
            code_then ^
            Printf.sprintf "\tmv a%d, a%d\n" result_reg reg_then ^
            Printf.sprintf "\tj %s\n" label_end ^
            Printf.sprintf "%s:\n" label_else ^
            code_else ^
            Printf.sprintf "\tmv a%d, a%d\n" result_reg reg_else ^
            Printf.sprintf "%s:\n" label_end
          in
          code, result_reg
      | Func (x, body) ->
          let fvs = free_vars body [x] in
          let num_free = List.length fvs in
          let func_id = fresh_label "func" in

          (* 为函数参数分配虚拟寄存器 *)
          let param_reg = fresh_vreg () in
          let local_env = [(x, param_reg)] in
          
          (* 为闭包变量分配虚拟寄存器 *)
          let closure_regs = List.map (fun _ -> fresh_vreg ()) fvs in
          let closure_env = List.combine fvs closure_regs in
          
          let func_body_code, ret_reg = compile_expr_func local_env closure_env body in
          
          (* 生成函数代码 *)
          let func_prologue = 
            Printf.sprintf "%s:\n" func_id
          in
          
          (* 把返回值移到 a0 寄存器 *)
          let ret_move = 
            if ret_reg <> 0 then Printf.sprintf "\tmv a0, a%d\n" ret_reg
            else ""
          in
          
          let func_epilogue = "\tret\n" in
          let func_code = func_prologue ^ func_body_code ^ ret_move ^ func_epilogue in
          functions := !functions @ [func_code];

          (* 生成闭包创建代码 *)
          let result_reg = fresh_vreg () in
          let closure_size = 8 * (1 + num_free) in
          let alloc_code = Printf.sprintf "\tli a%d, %d\n\tmv a0, a%d\n\tjal ra, malloc\n\tmv a%d, a0\n" 
                                            result_reg closure_size result_reg result_reg in
          
          let store_code_ptr = Printf.sprintf "\tla t0, %s\n\tsd t0, 0(a%d)\n" func_id result_reg in
          
          (* 保存自由变量到闭包中 *)
          let store_free_vars = 
            List.mapi (fun i v ->
              try 
                let src_reg = List.assoc v env in
                Printf.sprintf "\tsd a%d, %d(a%d)\n" src_reg (8 * (i + 1)) result_reg
              with Not_found -> 
                failwith ("Unbound free var: " ^ v)
            ) fvs |> String.concat ""
          in
          
          alloc_code ^ store_code_ptr ^ store_free_vars, result_reg
      | App (e1, e2) ->
          let code_f, reg_f = compiler_expr env e1 in
          let code_arg, reg_arg = compiler_expr env e2 in
          
          (* 保存函数指针和参数 *)
          let tmp_reg = fresh_vreg () in
          let env_reg = fresh_vreg () in
          
          (* 调用前准备 *)
          let setup_code = 
            Printf.sprintf "\tmv a%d, a%d\n" tmp_reg reg_f ^
            Printf.sprintf "\tmv a0, a%d\n" reg_arg ^
            Printf.sprintf "\taddi a%d, a%d, 8\n" env_reg tmp_reg ^
            Printf.sprintf "\tld t0, 0(a%d)\n" tmp_reg
          in
          
          (* 函数调用 *)
          let call_code = "\tjalr ra, 0(t0)\n" in
          
          (* 结果已在 a0 中，移到新的虚拟寄存器 *)
          let result_reg = fresh_vreg () in
          let result_move = Printf.sprintf "\tmv a%d, a0\n" result_reg in
          
          code_f ^ code_arg ^ setup_code ^ call_code ^ result_move, result_reg

and compile_expr_func (local_env : (string * int) list) (closure_env : (string * int) list) (expr : expr) : string * int =
  match expr with
  | Int n -> 
      let result_reg = fresh_vreg () in
      Printf.sprintf "\tli a%d, %d\n" result_reg n, result_reg
  | Bool b ->
      let result_reg = fresh_vreg () in
      Printf.sprintf "\tli a%d, %d\n" result_reg (if b then 1 else 0), result_reg
  | Var x ->
      if List.mem_assoc x local_env then
        "", List.assoc x local_env  (* 局部变量已在寄存器中 *)
      else if List.mem_assoc x closure_env then
        let idx = List.assoc x closure_env in
        let result_reg = fresh_vreg () in
        Printf.sprintf "\tld a%d, %d(a1)\n" result_reg (8 * idx), result_reg
      else
        failwith ("Unbound variable in function: " ^ x)
  | Binop (op, e1, e2) ->
      (match op with
      | Add ->
          (match e2 with
          | Int n ->
              let code1, reg1 = compile_expr_func local_env closure_env e1 in
              let result_reg = fresh_vreg () in
              code1 ^ Printf.sprintf "\taddi a%d, a%d, %d\n" result_reg reg1 n, result_reg
          | _ ->
              let code1, reg1 = compile_expr_func local_env closure_env e1 in
              let code2, reg2 = compile_expr_func local_env closure_env e2 in
              let result_reg = fresh_vreg () in
              code1 ^ code2 ^ Printf.sprintf "\tadd a%d, a%d, a%d\n" result_reg reg1 reg2, result_reg)
      | Mul ->
          (match e2 with
          | Int n when is_power_of_two n ->
              let code1, reg1 = compile_expr_func local_env closure_env e1 in
              let shift = log2 n in
              let result_reg = fresh_vreg () in
              code1 ^ Printf.sprintf "\tslli a%d, a%d, %d\n" result_reg reg1 shift, result_reg
          | _ ->
              let code1, reg1 = compile_expr_func local_env closure_env e1 in
              let code2, reg2 = compile_expr_func local_env closure_env e2 in
              let result_reg = fresh_vreg () in
              code1 ^ code2 ^ Printf.sprintf "\tmul a%d, a%d, a%d\n" result_reg reg1 reg2, result_reg)
      | Sub ->
          (match e2 with
          | Int n ->
              let code1, reg1 = compile_expr_func local_env closure_env e1 in
              let result_reg = fresh_vreg () in
              code1 ^ Printf.sprintf "\taddi a%d, a%d, %d\n" result_reg reg1 (-n), result_reg
          | _ ->
              let code1, reg1 = compile_expr_func local_env closure_env e1 in
              let code2, reg2 = compile_expr_func local_env closure_env e2 in
              let result_reg = fresh_vreg () in
              code1 ^ code2 ^ Printf.sprintf "\tsub a%d, a%d, a%d\n" result_reg reg1 reg2, result_reg)
      | Div ->
          let code1, reg1 = compile_expr_func local_env closure_env e1 in
          let code2, reg2 = compile_expr_func local_env closure_env e2 in
          let result_reg = fresh_vreg () in
          code1 ^ code2 ^ Printf.sprintf "\tdiv a%d, a%d, a%d\n" result_reg reg1 reg2, result_reg
      | Leq ->
          let code1, reg1 = compile_expr_func local_env closure_env e1 in
          let code2, reg2 = compile_expr_func local_env closure_env e2 in
          let result_reg = fresh_vreg () in
          code1 ^ code2 ^ 
          Printf.sprintf "\tsgt a%d, a%d, a%d\n\txori a%d, a%d, 1\n" 
              result_reg reg1 reg2 result_reg result_reg, 
          result_reg)
  | If (cond, e_then, e_else) ->
      let code_cond, reg_cond = compile_expr_func local_env closure_env cond in
      let code_then, reg_then = compile_expr_func local_env closure_env e_then in
      let code_else, reg_else = compile_expr_func local_env closure_env e_else in
      
      let result_reg = fresh_vreg () in
      let label_else = fresh_label "Lelse" in
      let label_end = fresh_label "Lend" in
      
      let code = 
        code_cond ^
        Printf.sprintf "\tbeq a%d, x0, %s\n" reg_cond label_else ^
        code_then ^
        Printf.sprintf "\tmv a%d, a%d\n" result_reg reg_then ^
        Printf.sprintf "\tj %s\n" label_end ^
        Printf.sprintf "%s:\n" label_else ^
        code_else ^
        Printf.sprintf "\tmv a%d, a%d\n" result_reg reg_else ^
        Printf.sprintf "%s:\n" label_end
      in
      code, result_reg
  | Let (x, e1, e2) ->
      let code1, reg1 = compile_expr_func local_env closure_env e1 in
      let local_env' = (x, reg1) :: local_env in
      let code2, reg2 = compile_expr_func local_env' closure_env e2 in
      code1 ^ code2, reg2
  | Func _ | App _ -> 
      failwith "Nested functions not fully supported in function bodies"

let compiler_program (e : expr) : string =
  (* 重置虚拟寄存器计数器 *)
  vreg_count := 0;
  functions := [];
  
  let body_code, result_reg = compiler_expr [] e in
  
  (* 将结果移到 a0 寄存器 *)
  let result_move = 
    if result_reg <> 0 then Printf.sprintf "\tmv a0, a%d\n" result_reg
    else ""
  in
  
  let prologue = 
    ".text\n\
    .global main\n\
    main:\n"
  in
  
  let epilogue = "\tret\n" in
  
  let func_code = String.concat "\n" !functions in
  prologue ^ body_code ^ result_move ^ epilogue ^ "\n" ^ func_code
  
let () =
  let filename = "test/simpl_test6.in" in
  let in_channel = open_in filename in
  let file_content = really_input_string in_channel (in_channel_length in_channel) in
  close_in in_channel;

  let ast = parse file_content in 
  Printf.printf "AST: %s\n" (string_of_expr ast);

  let output_file = Sys.argv.(1) in
  let oc = open_out output_file in

  let asm_code = compiler_program ast in

  output_string oc asm_code;
  close_out oc;
  Printf.printf "Generated RISC-V code saved to: %s\n" output_file