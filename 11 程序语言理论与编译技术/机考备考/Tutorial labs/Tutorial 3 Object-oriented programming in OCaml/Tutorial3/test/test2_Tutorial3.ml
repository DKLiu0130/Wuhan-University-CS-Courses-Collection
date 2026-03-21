open QCheck
open Solution_Tutorial3.Solution2

(* 测试创建账户 *)
let test_create_account =
  Test.make ~name:"Create account initializes correctly"
    (pair int string)
    (fun (id, owner) ->
      let account = create_account id owner in
      account.account_id = id
      && account.owner = owner
      && account.balance = 0
      && account.transactions = [])

(* 测试存款操作 *)
let test_deposit =
  Test.make ~name:"Deposit increases balance and records transaction"
    (triple int string int)
    (fun (id, owner, amount) ->
      let account = create_account id owner in
      try
        deposit account amount;
        if amount > 0 then
          account.balance = amount
          && account.transactions = [Deposit amount]
        else
          false (* 如果存款金额为负数，应该抛出异常 *)
      with
      | InvalidDeposit -> amount < 0)

(* 测试取款操作 *)
let test_withdraw =
  Test.make ~name:"Withdraw decreases balance and records transaction"
    (quad int string int int)
    (fun (id, owner, deposit_amount, withdraw_amount) ->
      let account = create_account id owner in
      try
        if deposit_amount < 0 then (
          deposit account deposit_amount; (* 这里会抛出异常 *)
          false
        ) else (
          deposit account deposit_amount;
          withdraw account withdraw_amount;
          if withdraw_amount > 0 && deposit_amount >= withdraw_amount then
            account.balance = deposit_amount - withdraw_amount
            && account.transactions = [Withdrawal withdraw_amount; Deposit deposit_amount]
          else
            false (* 如果余额不足或取款金额为负数，应该抛出异常 *)
        )
      with
      | InvalidDeposit -> deposit_amount < 0
      | InsufficientFunds -> withdraw_amount > 0 && deposit_amount < withdraw_amount
      | InvalidWithdrawal -> withdraw_amount < 0)

(* 测试获取余额 *)
let test_get_balance =
  Test.make ~name:"Get balance returns correct balance"
    (triple int string int)
    (fun (id, owner, amount) ->
      let account = create_account id owner in
      try
        if amount < 0 then (
          deposit account amount; (* 这里会抛出异常 *)
          false
        ) else (
          deposit account amount;
          get_balance account = if amount > 0 then amount else 0
        )
      with
      | InvalidDeposit -> amount < 0)

(* 运行测试 *)
let () =
  QCheck_runner.run_tests_main
    [ test_create_account
    ; test_deposit
    ; test_withdraw
    ; test_get_balance
    ]