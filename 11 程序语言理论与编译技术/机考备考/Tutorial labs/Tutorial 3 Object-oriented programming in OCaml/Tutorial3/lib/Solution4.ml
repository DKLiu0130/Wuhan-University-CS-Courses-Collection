(* 宝可梦类
  - name: 宝可梦名称
  - hp: 宝可梦生命值
  - attack: 宝可梦攻击力
  - take_damage: 宝可梦受到伤害时调用的方法
*)
module type Pokemon = sig
  val name : string
  val hp : int ref
  val attack : int
  val take_damage : int -> unit
end

(* 皮卡丘类
  - name: 皮卡丘名称
  - hp: 皮卡丘生命值
  - attack: 皮卡丘攻击力
  - take_damage: 皮卡丘受到伤害时调用的方法
*)
module Pikachu : Pokemon = struct
  let name = "Pikachu"
  let hp = ref 100
  let attack = 20
  let take_damage dmg = hp := max 0 (!hp - dmg)
end

(* 小火龙类
  - name: 小火龙名称
  - hp: 小火龙生命值
  - attack: 小火龙攻击力
  - take_damage: 小火龙受到伤害时调用的方法
*)
module Charmander : Pokemon = struct
  let name = "Charmander"
  let hp = ref 80
  let attack = 25
  let take_damage dmg = hp := max 0 (!hp - dmg)
end

(* 宝可梦战斗模块
  - P1: 宝可梦1
  - P2: 宝可梦2
  - fight: 宝可梦之间的战斗函数
  - print_winner: 打印获胜者的函数
*)
module Battle (P1 : Pokemon) (P2 : Pokemon) = struct
  let rec fight () =
    P2.take_damage P1.attack;
    if !(P2.hp) = 0 then ()
    else (
      P1.take_damage P2.attack;
      if !(P1.hp) > 0 then fight ()
    )

  let print_winner () =
    if !(P1.hp) > 0 then
      Printf.printf "%s wins!\n" P1.name
    else
      Printf.printf "%s wins!\n" P2.name
end
