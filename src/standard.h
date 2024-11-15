#include <stdarg.h>
#include <stdio.h>
#include <stdlib.h>
#include "types.h"

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

void printfSymbolTable() {
    struct symtab *p;

    for (int i = 0; i < nsyms; i++) {
            p = &symbols[i];
            if (p->typ == I64){
                printf("%s [I64]\n", p->id);
            }else {
                printf("%s [F64]\n", p->id);
            }
    }
}