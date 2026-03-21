let compose (f1 : 'b -> 'c) (f2 : 'a -> 'b) a = f1 (f2 a)
let double x = x * 2
let add x = x + 1
let f = compose double add;;

print_int (f 3)
