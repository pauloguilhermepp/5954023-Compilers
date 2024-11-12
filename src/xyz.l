%{
#include <stdlib.h>
#include "xyz.tab.h" 
#include "types.h"

extern int yyerror (char const *msg, ...);
%}

%option noyywrap nodefault yylineno
%%
"fn"                      { return FN; }
"return"                  { return RETURN; }
"main"                    { return MAIN; }
"if"                      { return IF; }
"else"                    { return ELSE; }
"while"                   { return WHILE; }
"printfSymbolTable"       { return PST; }
"var"                     { return VAR;}
"i64"                     { yylval.typ = I64; return T_I64; }
"f64"                     { yylval.typ = F64; return T_F64; }
"&&"                      { return AND; }
"||"                      { return OR; }
"=="                      { return EQ; }
"!="                      { return NE; }
">="                      { return GE; }
"<="                      { return LE; }
"//".*                    { ; /* Ignore */ }
["',:;=+*/%<>(){}!-]      { return yytext[0]; }
[0-9]+                    { yylval.tval.val.ival = atoi(yytext); return INT_LITERAL; }
[0-9]+"."[0-9]*           { yylval.tval.val.fval = atof(yytext); return FLOAT_LITERAL; }
[a-zA-Z][a-zA-Z0-9_]*     { yylval.sval = strdup(yytext); return IDENTIFIER; }
[ \t\r\n]                 { ; /* ignore */ }
.                         { yyerror("Unknown token %s\n", yytext); }
%%