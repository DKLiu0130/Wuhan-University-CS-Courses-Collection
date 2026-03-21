let fib (num : int) =
  let rec fib_inner num x1 x2 =
    if num > 0
    then fib_inner (num - 1) x2 (x1 + x2)
    else if num < 0
    then failwith "wrong para"
    else x1
  in
  fib_inner num 0 1
;;

print_int (fib 19)
