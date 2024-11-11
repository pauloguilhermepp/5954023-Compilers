%{
#include <stdarg.h>
#include <stdio.h>
#include <stdlib.h>

#define MAXTOKEN 64
#define MAXSYMS 256

union value_union {
        int ival;
        double fval;
};

struct symtab {
        char id[MAXTOKEN];
        union value_union val;
};

extern void assign(char *id, union value_union ival);
extern int yyerror (char const *msg, ...);
extern int yylex();

static struct symtab symbols[MAXSYMS];
static int nsyms = 0;

int yydebug = 1;

union value_union sum (union value_union x1, union value_union x2){
        union value_union result;
        result.ival = x1.ival + x2.ival;
        result.fval = x1.fval + x2.fval;

        return result;
}

union value_union sub (union value_union x1, union value_union x2){
        union value_union result;
        result.ival = x1.ival - x2.ival;
        result.fval = x1.fval - x2.fval;

        return result;
}

union value_union mult (union value_union x1, union value_union x2){
        union value_union result;
        result.ival = x1.ival * x2.ival;
        result.fval = x1.fval * x2.fval;

        return result;
}

union value_union divs (union value_union x1, union value_union x2){
        union value_union result;
        result.ival = x1.ival / x2.ival;
        result.fval = x1.fval / x2.fval;

        return result;
}
%}

%union {
        union value_union val;
        char *sval;
}

%token FN RETURN MAIN
%token IF ELSE
%token WHILE PST
%token VAR T_I64 T_F64
%token AND OR EQ NE GE LE
%token <val.ival> INT_LITERAL
%token <val.fval> FLOAT_LITERAL
%token <sval> IDENTIFIER

%type  <val> expr

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
function        : FN MAIN '(' ')' '{' assign_list RETURN INT_LITERAL ';' '}'
                ;
assign_list     : assignment
                | assignment  assign_list
                ;

assignment      : VAR IDENTIFIER ':' T_I64 '=' expr ';'         { assign($2, $6); }
                | VAR IDENTIFIER ':' T_F64 '=' expr ';'         { assign($2, $6); }
                | PST '(' ')' ';'                               {int i; 
                                                                struct symtab *p; 
                                                                for (i = 0; i < nsyms; i++) {
                                                                        p = &symbols[i];
                                                                        printf("%s = %d, %f\n", p->id, p->val.ival, p->val.fval);
                                                                }}
                ;

expr            : expr '+' expr                 { $$ = sum($1, $3); }
                | expr '-' expr                 { $$ = sub($1, $3); }
                | expr '*' expr                 { $$ = mult($1, $3); }
                | expr '/' expr                 { $$ = divs($1, $3); }
                | INT_LITERAL                   { $$.ival = $1; }
                | FLOAT_LITERAL                 { $$.fval = $1; }
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

static struct symtab *lookup(char *id) {
        int i;
        struct symtab *p;

        for (i = 0; i < nsyms; i++) {
                p = &symbols[i];
                if (strncmp(p->id, id, MAXTOKEN) == 0)
                        return p;
        }

        return NULL;
}

static void install(char *id, union value_union val) {
        struct symtab *p;

        p = &symbols[nsyms++];
        strncpy(p->id, id, MAXTOKEN);
        p->val = val;
}

void assign(char *id, union value_union val) {
        struct symtab *p;

        p = lookup(id);
        if(p == NULL)
                install(id, val);
        else
                p->val = val;
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