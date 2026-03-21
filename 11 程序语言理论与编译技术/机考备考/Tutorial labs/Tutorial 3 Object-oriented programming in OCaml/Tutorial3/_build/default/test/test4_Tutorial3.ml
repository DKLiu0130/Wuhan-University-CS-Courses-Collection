open QCheck
open Solution_Tutorial3.Solution4

(* 测试宝可梦的初始状态 *)
let test_pokemon_initial_state =
  Test.make ~name:"Pokemon initial state is correct" unit (fun () ->
      Pikachu.hp := 100;
      Charmander.hp := 80;
      Pikachu.name = "Pikachu"
      && Charmander.name = "Charmander"
      && !(Pikachu.hp) = 100
      && !(Charmander.hp) = 80
      && Pikachu.attack = 20
      && Charmander.attack = 25)

(* 测试宝可梦受到伤害 *)
let test_pokemon_take_damage =
  Test.make ~name:"Pokemon takes damage correctly" int (fun dmg ->
      Pikachu.hp := 100;
      Pikachu.take_damage dmg;
      !(Pikachu.hp) = max 0 (100 - dmg))

(* 测试宝可梦战斗 *)
let test_pokemon_battle =
  Test.make ~name:"Pokemon battle produces a winner" unit (fun () ->
      Pikachu.hp := 100;
      Charmander.hp := 80;
      let module BattleTest = Battle (Pikachu) (Charmander) in
      BattleTest.fight ();
      !(Pikachu.hp) = 0 || !(Charmander.hp) = 0)

(* 测试战斗结果 *)
let test_battle_winner =
  Test.make ~name:"Battle winner is correct" unit (fun () ->
      Pikachu.hp := 100;
      Charmander.hp := 80;
      let module BattleTest = Battle (Pikachu) (Charmander) in
      BattleTest.fight ();
      if !(Pikachu.hp) > 0 then
        !(Charmander.hp) = 0
      else
        !(Pikachu.hp) = 0)

(* 运行测试 *)
let () =
  QCheck_runner.run_tests_main
    [ test_pokemon_initial_state
    ; test_pokemon_take_damage
    ; test_pokemon_battle
    ; test_battle_winner
    ]