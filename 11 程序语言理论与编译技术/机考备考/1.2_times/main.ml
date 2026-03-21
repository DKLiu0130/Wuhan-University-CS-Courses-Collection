let prod (lst : int list) =
  let rec prod_inner lst result =
    match lst with
    | x :: y -> prod_inner y (result * x)
    | _ -> result
  in
  prod_inner lst 1
;;

print_int (prod [ 1; 2; 3; 4; 5 ])
