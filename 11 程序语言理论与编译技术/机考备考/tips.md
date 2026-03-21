Your file is embedded into the testing project as a module!
## Tips for Tutorial 1
- Parameter: `(lst : int list list)` or `('a -> int)`.
- `rec` supported in inner recursive.
- Parameter name should be distinguishable.
- Build functions from small to large.
## Tips for Tutorial 2
- Recursive function transitions.
- List functions: map, iter, map2, iter2, mem(mem+map), filter, rev, fold_left.
- String functions: iter, to_seq (+of_seq), split_on_char
    ```ocaml
    type a_type = Add | Next;;
    let f (c:char) = 
    match c with 
    | '+' -> Add
    | '>' -> Next
    | _ -> failwith "wrong input";;

    let a_to_string str = List.map f (List.of_seq (String.to_seq str))
    ```
    - Another one:`let string_to_char_list str = String.fold_right (fun c acc -> c :: acc) str []`.
- *2.4.

## Tips for Tutorial 3
- Modules used for: 
    - as global variables;
    - as a function set.
- Classes used for Inheritance.
- Functors transformation is important.

## Tips for Tutorial 4
- For yacc: ast, parser.mly, lexer.mll, main...
- For recursive descent: ast, token, parser.ml, lexer.mll, main... Focus on the interface of each state.
- For symbol table: can be build while constructing AST.

## Tips for Tutorial 5
- Includes: Calculator, SimPL, Lambda.
- Calculator: Basic implementation of parser, interp, big_interp.
- SimPL: Based on Calculator, add "let" and "if" statement, the former need substitution.
- Lambda: Not included.
