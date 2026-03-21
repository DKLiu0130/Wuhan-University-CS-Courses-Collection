 // 创建 lib/parser.mly
 %{
 open Ast
 %}
 %token <int> INT
 %token PLUS MINUS TIMES DIV EOF
 %start main
 %type <Ast.expr> main
 %%
 main:
 expr EOF { $1 }
 ;
 expr:
 | term PLUS expr { Add($1, $3) }
 | term MINUS expr { Sub($1, $3) }
 | term { $1 }
 ;
term:
 | factor TIMES term { Mul($1, $3) }
 | factor DIV term { Div($1, $3) }
 | factor { $1 }
 ;
 factor:
 | INT { Num($1) }
 ;