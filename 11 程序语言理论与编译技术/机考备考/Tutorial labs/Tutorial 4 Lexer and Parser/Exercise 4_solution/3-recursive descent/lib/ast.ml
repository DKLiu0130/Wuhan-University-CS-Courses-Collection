type term =
  | True                    
  | False                   
  | Zero                   
  | Succ of term             
  | Pred of term            
  | IsZero of term           
  | If of term * term * term 