(* Usage1 : as global variables *)
module type Example_1 = sig
  val lst : int list ref
  val append_lst : int -> unit
  val getlst : unit -> int list
end

module Example_1 : Example_1 = struct
  let lst = ref [ 1; 2; 3 ]
  let append_lst num = lst := !lst @ [ num ]
  let getlst () = !lst
end

let f num = print_endline (string_of_int num);;

Example_1.append_lst 4;;
List.iter f (Example_1.getlst ())

(* Usage2 : as a function set *)
module type Example_2 = sig
  type person =
    { name : string
    ; mutable score : int
    }

  val double_score : person -> person
end

module Example_2 : Example_2 = struct
  type person =
    { name : string
    ; mutable score : int
    }

  let double_score p =
    p.score <- p.score * 2;
    p
  ;;
end

open Example_2

let ex = { name = "happy"; score = 100 };;

Example_2.double_score ex
