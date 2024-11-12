%{
#include <stdarg.h>
#include <stdio.h>
#include <stdlib.h>

#define MAXTOKEN 64
#define MAXSYMS 256

enum type_enum {
        I64, F64
};

union value_union {
        int ival;
        double fval;
};

struct typed_value {
        enum type_enum typ;
        union value_union val;
};

struct symtab {
        char id[MAXTOKEN];
        struct typed_value tval;
};

extern void assign(char *id, char *targTyp, struct typed_value tval);
extern int yyerror (char const *msg, ...);
extern int yylex();

static struct symtab symbols[MAXSYMS];
static int nsyms = 0;

int yydebug = 1;

struct typed_value sum (struct typed_value tval1, struct typed_value tval2){
        struct typed_value result;
        if (tval1.typ == I64 && tval2.typ == I64){
                result.typ = I64;
                result.val.ival = tval1.val.ival + tval2.val.ival;
                return result;
        }else if (tval1.typ == I64 && tval2.typ == F64){
                result.typ = F64;
                result.val.fval = tval1.val.ival + tval2.val.fval;
                return result;
        }else if (tval1.typ == F64 && tval2.typ == I64){
                result.typ = F64;
                result.val.fval = tval1.val.fval + tval2.val.ival;
                return result;
        }else {
                result.typ = F64;
                result.val.fval = tval1.val.fval + tval2.val.fval;
                return result;
        }
}

struct typed_value sub (struct typed_value tval1, struct typed_value tval2){
        struct typed_value result;
        if (tval1.typ == I64 && tval2.typ == I64){
                result.typ = I64;
                result.val.ival = tval1.val.ival - tval2.val.ival;
                return result;
        }else if (tval1.typ == I64 && tval2.typ == F64){
                result.typ = F64;
                result.val.fval = tval1.val.ival - tval2.val.fval;
                return result;
        }else if (tval1.typ == F64 && tval2.typ == I64){
                result.typ = F64;
                result.val.fval = tval1.val.fval - tval2.val.ival;
                return result;
        }else {
                result.typ = F64;
                result.val.fval = tval1.val.fval - tval2.val.fval;
                return result;
        }
}

struct typed_value mult (struct typed_value tval1, struct typed_value tval2){
        struct typed_value result;
        if (tval1.typ == I64 && tval2.typ == I64){
                result.typ = I64;
                result.val.ival = tval1.val.ival * tval2.val.ival;
                return result;
        }else if (tval1.typ == I64 && tval2.typ == F64){
                result.typ = F64;
                result.val.fval = tval1.val.ival * tval2.val.fval;
                return result;
        }else if (tval1.typ == F64 && tval2.typ == I64){
                result.typ = F64;
                result.val.fval = tval1.val.fval * tval2.val.ival;
                return result;
        }else {
                result.typ = F64;
                result.val.fval = tval1.val.fval * tval2.val.fval;
                return result;
        }
}

struct typed_value divs (struct typed_value tval1, struct typed_value tval2){
        struct typed_value result;
        if (tval1.typ == I64 && tval2.typ == I64){
                result.typ = I64;
                result.val.ival = tval1.val.ival / tval2.val.ival;
                return result;
        }else if (tval1.typ == I64 && tval2.typ == F64){
                result.typ = F64;
                result.val.fval = tval1.val.ival / tval2.val.fval;
                return result;
        }else if (tval1.typ == F64 && tval2.typ == I64){
                result.typ = F64;
                result.val.fval = tval1.val.fval / tval2.val.ival;
                return result;
        }else {
                result.typ = F64;
                result.val.fval = tval1.val.fval / tval2.val.fval;
                return result;
        }
}
%}

%union {
        struct typed_value tval;
        char *sval;
}

%token FN RETURN MAIN
%token IF ELSE
%token WHILE PST
%token VAR
%token AND OR EQ NE GE LE
%token <sval> T_I64 T_F64
%token <tval.val.ival> INT_LITERAL
%token <tval.val.fval> FLOAT_LITERAL
%token <sval> IDENTIFIER

%type  <tval> expr

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

assignment      : VAR IDENTIFIER ':' T_I64 '=' expr ';'         { assign($2, $4, $6); }
                | VAR IDENTIFIER ':' T_F64 '=' expr ';'         { assign($2, $4, $6); }
                | PST '(' ')' ';'                               {int i; 
                                                                struct symtab *p; 
                                                                for (i = 0; i < nsyms; i++) {
                                                                        p = &symbols[i];
                                                                        printf("%s = %d, %f\n", p->id, p->tval.val.ival, p->tval.val.fval);
                                                                }}
                ;

expr            : expr '+' expr                 { $$ = sum($1, $3); }
                | expr '-' expr                 { $$ = sub($1, $3); }
                | expr '*' expr                 { $$ = mult($1, $3); }
                | expr '/' expr                 { $$ = divs($1, $3); }
                | INT_LITERAL                   { $$.val.ival = $1; $$.typ = I64;}
                | FLOAT_LITERAL                 { $$.val.fval = $1; $$.typ = F64;}
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

static void install(char *id, char *targTyp, struct typed_value tval) {
        struct symtab *p;

        p = &symbols[nsyms++];
        strncpy(p->id, id, MAXTOKEN);

        if (strncmp(targTyp, "I64", 3) == 0 && tval.typ == F64) {
                p->tval.typ = I64;
                p->tval.val.ival = tval.val.fval;
        }else if (strncmp(targTyp, "F64", 3) == 0 && tval.typ == I64 ) {
                p->tval.typ = F64;
                p->tval.val.fval = tval.val.ival;
        }
}

void assign(char *id, char *targTyp, struct typed_value tval) {
        struct symtab *p;

        p = lookup(id);
        if(p == NULL){
                install(id, targTyp, tval);
        }else {
                if (strncmp(targTyp, "I64", 3) == 0 && tval.typ == F64 ) {
                        p->tval.val.ival = tval.val.fval;
                }else if (strncmp(targTyp, "F64", 3) == 0 && tval.typ == I64 ) {
                        p->tval.val.fval = tval.val.ival;
                }else{
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