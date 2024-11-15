%{
#include "standard.h"
#include "stack.h"

Stack scopeStack = {.top = -1};
%}

%union {
        struct typed_value tval;
        enum type_enum typ;
        char *sval;
}

%token FN RETURN MAIN
%token IF ELSE
%token WHILE PST
%token VAR
%token AND OR EQ NE GE LE
%token <typ> T_I64 T_F64
%token <tval.val.ival> INT_LITERAL
%token <tval.val.fval> FLOAT_LITERAL
%token <sval> IDENTIFIER

%type  <tval> expr

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

function        : FN IDENTIFIER '(' ')' '{' { 
                      push(&scopeStack, $2);; 
                  } 
                  statement_list RETURN INT_LITERAL ';' '}' { 
                      pop(&scopeStack); 
                  }
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

assignment      : IDENTIFIER ':' T_I64 '=' expr         { assign($1, $3, $5); }
                | IDENTIFIER ':' T_F64 '=' expr         { assign($1, $3, $5); }
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

expr            : expr '+' expr                 { $$ = sum($1, $3); }
                | expr '-' expr                 { $$ = sub($1, $3); }
                | expr '*' expr                 { $$ = mult($1, $3); }
                | expr '/' expr                 { $$ = divs($1, $3); }
                | expr AND expr                 { $$.val.ival = 0; $$.typ = I64;}
                | expr OR  expr                 { $$.val.ival = 0; $$.typ = I64;}
                | expr EQ  expr                 { $$.val.ival = 0; $$.typ = I64;}
                | expr NE  expr                 { $$.val.ival = 0; $$.typ = I64;}
                | expr GE  expr                 { $$.val.ival = 0; $$.typ = I64;}
                | expr LE  expr                 { $$.val.ival = 0; $$.typ = I64;}
                | expr '>' expr                 { $$.val.ival = 0; $$.typ = I64;}
                | expr '<' expr                 { $$.val.ival = 0; $$.typ = I64;}
                | INT_LITERAL                   { $$.val.ival = $1; $$.typ = I64;}
                | FLOAT_LITERAL                 { $$.val.fval = $1; $$.typ = F64;}
                | IDENTIFIER                    { struct symtab *p; p = lookup($1); $$ = p->tval;}
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

struct symtab *lookup(char *id) {
        int i;
        struct symtab *p;

        for (i = 0; i < nsyms; i++) {
                p = &symbols[i];
                if (strncmp(p->id, id, MAXTOKEN) == 0)
                        return p;
        }

        return NULL;
}

static void install(char *id, enum type_enum targTyp, struct typed_value tval) {
        struct symtab *p;
        char *scope = getStack(&scopeStack);

        p = &symbols[nsyms++];
        strncpy(p->id, id, MAXTOKEN);
        strncpy(p->scope, scope, MAXTOKEN);

        if (targTyp == I64 && tval.typ == F64) {
                p->tval.typ = I64;
                p->tval.val.ival = tval.val.fval;
        }else if (targTyp == F64 && tval.typ == I64 ) {
                p->tval.typ = F64;
                p->tval.val.fval = tval.val.ival;
        }else {
                p->tval = tval;
        }
}

void assign(char *id, enum type_enum targTyp, struct typed_value tval) {
        struct symtab *p;

        p = lookup(id);
        if(p == NULL){
                install(id, targTyp, tval);
        }else {
                if (targTyp == I64 && tval.typ == F64 ) {
                        p->tval.val.ival = tval.val.fval;
                }else if (targTyp == F64 == 0 && tval.typ == I64 ) {
                        p->tval.val.fval = tval.val.ival;
                }else {
                        p->tval = tval;
                }
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