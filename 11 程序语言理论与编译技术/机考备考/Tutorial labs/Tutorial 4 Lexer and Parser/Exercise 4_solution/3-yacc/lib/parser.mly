%{
  open Ast
%}

%token TRUE FALSE IF THEN ELSE ZERO SUCC PRED ISZERO EOF
%type <Ast.term> main
%start main

%%

main:
  term EOF { $1 } 

;

term:
  TRUE           { True } 
| FALSE          { False } 
| ZERO           { Zero } 
| SUCC term      { Succ($2) } 
| PRED term      { Pred($2) } 
| ISZERO term    { IsZero($2) } 
| IF term THEN term ELSE term { If($2, $4, $6) } 
;