%{
#include <stdlib.h>
#include "xyz.tab.h" 
#include "types.h"

%}

%option noyywrap nodefault yylineno
%%
"fn"                    { return FN; }
"return"                { return RETURN; }
"main"                  { yylval.sval = strdup(yytext); return MAIN; }
"if"                    { return IF; }
"else"                  { return ELSE; }
"while"                 { return WHILE; }
"var"                   { return VAR;}
"i64"                   { yylval.type = I64; return T_I64; }
"f64"                   { yylval.type = F64; return T_F64; }
"&&"                    { return AND; }
"||"                    { return OR; }
"=="                    { return EQ; }
"!="                    { return NE; }
">="                    { return GE; }
"<="                    { return LE; }
"//".*                  { ; /* Ignore */ }
["',:;=+*/%<>(){}!-]    { return yytext[0]; }
[+-]?[0-9]+             { return INT_LITERAL; }
[+-]?[0-9]+"."[0-9]*    { return FLOAT_LITERAL; }
[a-zA-Z][a-zA-Z0-9_]*   { yylval.sval = strdup(yytext); return IDENTIFIER; }
[ \t\r\n]               { ; /* ignore */ }
.                       { yyerror("Unknown token %s\n", yytext); }
%%