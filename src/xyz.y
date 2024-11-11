%{
#include <stdarg.h>
#include <stdio.h>
#include <stdlib.h>

#define MAXTOKEN 64
#define MAXSYMS 256

struct symtab {
        char id[MAXTOKEN];
        float fval;
        int ival;
};

extern void assign(char *id, int ival);
extern int yyerror (char const *msg, ...);
extern int yylex();

static struct symtab symbols[MAXSYMS];
static int nsyms = 0;

int yydebug = 1;
%}

%union {
        int ival;
        float fval;
        char *sval;
}

%token FN RETURN MAIN
%token IF ELSE
%token WHILE PST
%token VAR T_I64 T_f64
%token AND OR EQ NE GE LE
%token <ival> INT_LITERAL
%token <fval> FLOAT_LITERAL
%token <sval> IDENTIFIER

%type  <ival> expr

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
                | PST '(' ')' ';'                               {int i; 
                                                                struct symtab *p; 
                                                                for (i = 0; i < nsyms; i++) {
                                                                        p = &symbols[i];
                                                                        printf("%s=%d\n", p->id, p->ival);
                                                                }}
                ;

expr            : expr '+' expr                 { $$ = $1 + $3; }
                | expr '-' expr                 { $$ = $1 - $3; }
                | expr '*' expr                 { $$ = $1 * $3; }
                | expr '/' expr                 { $$ = $1 / $3; }
                | INT_LITERAL                   { $$ = $1; }
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

static void install(char *id, int ival) {
        struct symtab *p;

        p = &symbols[nsyms++];
        strncpy(p->id, id, MAXTOKEN);
        p->ival = ival;
}

void assign(char *id, int ival) {
        struct symtab *p;

        p = lookup(id);
        if(p == NULL)
                install(id, ival);
        else
                p->ival = ival;
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