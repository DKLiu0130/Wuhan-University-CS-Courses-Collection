module type Person = sig
  val life : int ref
  val change_life : int -> unit
end

module Fight (P1 : Person) (P2 : Person) = struct
  let winner () =
    if P1.life > P2.life then print_endline "p1 wins" else print_endline "p2 wins"
  ;;
end

module A : Person = struct
  let life = ref 10
  let change_life num = life := num
end

module B : Person = struct
  let life = ref 10
  let change_life num = life := num
end
;;

B.change_life 20

module Result = Fight (A) (B);;

Result.winner ()
