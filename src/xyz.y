%{
#include "standard.h"
%}

%union {
        enum type_enum type;
        char *sval;
}

%token FN RETURN
%token IF ELSE
%token WHILE
%token VAR
%token AND OR EQ NE GE LE
%token INT_LITERAL
%token FLOAT_LITERAL
%token <type> T_I64 T_F64
%token <sval> MAIN IDENTIFIER

%type  <type> type

%left OR
%left AND
%nonassoc EQ NE
%nonassoc '<' '>' GE LE
%left '+' '-'
%left '*' '/' '%'
%left '!'
%right '='

%start program

%%
program         : function_list { return 0;}              
                ;

function_list   : function
                | function function_list
                ;

function        : FN function_declaration '{' statement_list RETURN expr ';' '}' { pop(&scopeStack); }
                ;

function_declaration    : MAIN '(' ')'  { push(&scopeStack, $1); }
                        | IDENTIFIER    { push(&scopeStack, $1); }      '(' function_attributes ')'
                        ;

function_attributes     : /*epsilon*/ 
                        | identifier_list
                        ;

identifier_list         : IDENTIFIER type                       { safeAddVariable($1, $2); }
                        | IDENTIFIER type ',' identifier_list   { safeAddVariable($1, $2); }
                        ;

statement_list  : /*epsilon*/ 
                | statement  statement_list
                ;

statement       : attribution
                | assignment_list
                | function_call
                | conditional_statement
                | loop_statement
                ;

attribution     : IDENTIFIER '=' expr ';' { checkExistence($1); }
                | IDENTIFIER '+' '+' ';'  { checkExistence($1); }
                | IDENTIFIER '-' '-' ';'  { checkExistence($1); }
                ;

assignment_list : VAR variable_assignment_list
                ;

variable_assignment_list        : assignment ';'
                                | assignment ',' variable_assignment_list
                                ;

assignment      : IDENTIFIER ':' type '=' expr         { safeAddVariable($1, $3); }
                ;

type    : T_I64
        | T_F64
        ;

function_call           : IDENTIFIER '(' parameters_list ')' ';'
                        | IDENTIFIER '=' IDENTIFIER '(' parameters_list ')' ';'
                        ;

conditional_statement   : IF expr '{' statement_list '}' else_statement_list
                        | IF expr '{' statement_list RETURN expr ';' '}' else_statement_list
                        ;

parameters_list         : /*epsilon*/ 
                        | expression_list
                        ;

expression_list         : expr
                        | expr ',' expression_list
                        ;

else_statement_list     : /*epsilon*/ 
                        | ELSE IF expr '{' statement_list '}' else_statement_list
                        | ELSE IF expr '{' statement_list RETURN expr ';' '}' else_statement_list
                        | single_else_statement
                        ;

single_else_statement   : ELSE '{' statement_list '}'
                        | ELSE '{' statement_list RETURN expr ';' '}'
                        ;

loop_statement          : WHILE expr '{' statement_list '}'
                        | WHILE expr '{' statement_list RETURN expr ';' '}'
                        ;

expr            : '(' expr ')'
                | expr '+' expr
                | expr '-' expr
                | expr '*' expr
                | expr '/' expr
                | expr '%' expr
                | expr AND expr
                | expr OR  expr
                | expr EQ  expr
                | expr NE  expr
                | expr GE  expr
                | expr LE  expr
                | expr '>' expr
                | expr '<' expr
                | '!' expr
                | '-' expr
                | INT_LITERAL
                | FLOAT_LITERAL
                | IDENTIFIER
                ;
%%
#include "xyz.yy.c"

int main (int argc, char **argv) {
    FILE *fp;

    fp = fopen(argv[1], "r");
    if (!fp) {
        perror(argv[1]);
        return 1;
    }

    yyin = fp;
    do {
        yyparse();
    } while(!feof(yyin));

    printfSymbolTable();

    return EXIT_SUCCESS;
}