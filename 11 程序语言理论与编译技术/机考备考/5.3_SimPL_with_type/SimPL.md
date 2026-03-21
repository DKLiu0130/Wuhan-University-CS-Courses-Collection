# SimPL Syntax

Here is the BNF syntax definition for SimPL: 

```plaintext
e ::= x | i | b | e1 binop e2
    | if e1 then e2 else e3
    | let x = e1 in e2

binop ::= + | * | <=

x ::= <identifiers>

i ::= <integers>

b ::= true | false
```