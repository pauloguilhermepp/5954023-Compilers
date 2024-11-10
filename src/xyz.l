%{
#include <stdlib.h>
#include "xyz.tab.h" 

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
"var"                     { return VAR;}
"i64"                     { return T_I64; }
"f64"                     { return T_f64; }
"&&"                      { return AND; }
"||"                      { return OR; }
"=="                      { return EQ; }
"!="                      { return NE; }
">="                      { return GE; }
"<="                      { return LE; }
[\n"',:;=+*/%<>(){}!-]    { return yytext[0]; }
[0-9]+                    { yylval.ival = atoi(yytext); return INT_LITERAL; }
[0-9]+"."[0-9]*           { yylval.fval = atof(yytext); return FLOAT_LITERAL; }
[a-zA-Z][a-zA-Z0-9_]*     { yylval.sval = strdup(yytext); return IDENTIFIER; }
[ \t\r]                   { ; /* ignore */ }
.                         { yyerror("Unknown token %s\n", yytext); }
%%