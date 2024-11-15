%{
#include "standard.h"
#include "stack.h"

Stack scopeStack = {.top = -1};
%}

%union {
        enum type_enum typ;
        char *sval;
}

%token FN RETURN
%token IF ELSE
%token WHILE PST
%token VAR
%token AND OR EQ NE GE LE
%token INT_LITERAL
%token FLOAT_LITERAL
%token <typ> T_I64 T_F64
%token <sval> MAIN IDENTIFIER

%type  <typ> type

%left OR
%left AND
%nonassoc EQ NE
%nonassoc '<' '>' GE LE
%left '+' '-'
%left '*' '/'
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

function_declaration    : MAIN '(' ')'                                  { push(&scopeStack, $1); }
                        | IDENTIFIER '(' function_attributes ')'        { push(&scopeStack, $1); }
                        ;

function_attributes     : /*epsilon*/ 
                        | identifier_list
                        ;

identifier_list         : IDENTIFIER type                       { struct symtab *p; assign($1, $2); }
                        | IDENTIFIER type ',' identifier_list   { struct symtab *p; assign($1, $2); }
                        ;

statement_list  : statement
                | statement  statement_list
                ;

statement       : assignment_list
                | conditional_statement
                | loop_statement
                | printfSymbolTable
                ;

assignment_list : VAR variable_assignment_list
                ;

variable_assignment_list        : assignment ';'
                                | assignment ',' variable_assignment_list
                                ;

assignment      : IDENTIFIER ':' type '=' expr         { assign($1, $3); }
                ;

type    : T_I64
        | T_F64
        ;

conditional_statement   : IF '(' expr ')' '{' statement_list '}' else_statement_list
                        ;

else_statement_list     : /*epsilon*/ 
                        | ELSE IF '(' expr ')' '{' statement_list '}' else_statement_list
                        | single_else_statement
                        ;

single_else_statement   : ELSE '{' statement_list '}'
                        ;

loop_statement          : WHILE '(' expr ')' '{' statement_list '}'
                        ;

printfSymbolTable       : PST '(' ')' ';'               { printfSymbolTable(); }
                        ;

expr            : expr '+' expr
                | expr '-' expr
                | expr '*' expr
                | expr '/' expr
                | expr AND expr
                | expr OR  expr
                | expr EQ  expr
                | expr NE  expr
                | expr GE  expr
                | expr LE  expr
                | expr '>' expr
                | expr '<' expr
                | INT_LITERAL
                | FLOAT_LITERAL
                | IDENTIFIER
                ;
%%
#include "xyz.yy.c"

int yyerror(const char *msg, ...) {
	va_list args;

	va_start(args, msg);
	vfprintf(stderr, msg, args);
	va_end(args);

	exit(EXIT_FAILURE);
}

struct symtab *lookup(char *varName) {
        char *id = getStack(&scopeStack);
        struct symtab *p;

        strcat(id, varName);

        for (int i = 0; i < nsyms; i++) {
                p = &symbols[i];
                if (strncmp(p->id, id, MAXTOKEN) == 0)
                        return p;
        }

        return NULL;
}

static void install(char *varName, enum type_enum targTyp) {
        struct symtab *p;
        char *id = getStack(&scopeStack);

        strcat(id, varName);

        p = &symbols[nsyms++];
        p->typ = targTyp;
        strncpy(p->id, id, MAXTOKEN);
}

void assign(char *varName, enum type_enum targTyp) {
        struct symtab *p;

        p = lookup(varName);
        if(p == NULL){
                install(varName, targTyp);
        }
}

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

    return EXIT_SUCCESS;
}