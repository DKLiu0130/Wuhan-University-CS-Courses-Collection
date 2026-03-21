class type people_inter = object
  val name : string
  val mutable age : int
  method change_age : int -> unit
  method print_info : unit -> unit
end

class people (name : string) (age : int) : people_inter =
  object
    val name = name
    val mutable age = age
    method change_age num = age <- num

    method print_info () =
      print_endline ("name:" ^ name ^ "; age:" ^ string_of_int age ^ ";")
  end

class student (name : string) (age : int) (score : int) =
  object
    inherit people name age as super
    val mutable score = score
    method change_score num = score <- num
  end

let example = new student "allen" 20 100;;

example#change_age 21;;
example#print_info ()
