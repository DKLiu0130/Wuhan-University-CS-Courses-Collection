type token =
  | EOF
  | ID of string
  | NUM of int
  | ADD
  | SUB
  | MUL
  | DIV
  | LEFT
  | RIGHT
  | SEG
  | ASSIGN

(*   example:
a = 1;
b = 2;
a + b;

main -> start EOF
start -> expression ; start   |  epsilon
expression -> id = num | e
e -> t e1
e1 -> + t e1 | epsilon
t -> f t1
t1 -> * f t1 | epsilon
f -> id | (e)
first create an AST tree, then calculate value from the tree!
*)
