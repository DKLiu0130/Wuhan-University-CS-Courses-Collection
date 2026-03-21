(* 事务类型
  - Deposit: 存款
  - Withdrawal: 取款
*)
type transaction = 
  | Deposit of int 
  | Withdrawal of int

(* 银行账户类型
  - account_id: 账户ID
  - owner: 账户持有人
  - balance: 账户余额
  - transactions: 交易记录列表
*)
type bank_account = {
  account_id : int;
  owner : string;
  mutable balance : int;
  mutable transactions : transaction list;
}

(* 异常 *)
exception InvalidDeposit
exception InsufficientFunds
exception InvalidWithdrawal

(* 创建新账户 
  - id: 账户ID
  - owner: 账户持有人
  - 返回新创建的银行账户
*)
let create_account (id : int) (owner : string) : bank_account =
  { account_id = id; owner; balance = 0; transactions = [] }

(* 存款操作
  - account: 银行账户
  - amount: 存款金额
  - 如果金额大于0，则将金额添加到账户余额，并记录交易
  - 如果金额为负数，抛出 InvalidDeposit 异常
*)
let deposit (account : bank_account) (amount : int) : unit =
  if amount < 0 then raise InvalidDeposit
  else if amount > 0 then (
    account.balance <- account.balance + amount;
    account.transactions <- Deposit amount :: account.transactions
  )

(* 取款操作
  - account: 银行账户
  - amount: 取款金额
  - 如果金额大于0且账户余额足够，则从账户余额中扣除金额，并记录交易
  - 如果金额为负数，抛出 InvalidWithdrawal 异常
  - 如果余额不足，抛出 InsufficientFunds 异常
*)
let withdraw (account : bank_account) (amount : int) : unit =
  if amount < 0 then raise InvalidWithdrawal
  else if account.balance < amount then raise InsufficientFunds
  else if amount > 0 then (
    account.balance <- account.balance - amount;
    account.transactions <- Withdrawal amount :: account.transactions
  )

(* 获取账户余额
  - account: 银行账户
  - 返回账户余额
*)
let get_balance (account : bank_account) : int =
  account.balance

(* 打印交易记录
  - account: 银行账户
  - 打印账户的所有交易记录
*)
let print_transactions (account : bank_account) : unit =
  let print_transaction = function
    | Deposit amt -> Printf.printf "Deposit: %d\n" amt
    | Withdrawal amt -> Printf.printf "Withdrawal: %d\n" amt
  in
  List.iter print_transaction (List.rev account.transactions)