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

static void install(char *varName, enum type_enum targType) {
        struct symtab *p;
        char *id = getStack(&scopeStack);

        strcat(id, varName);

        p = &symbols[nsyms++];
        p->type = targType;
        strncpy(p->id, id, MAXTOKEN);
}

void assign(char *varName, enum type_enum targType) {
        struct symtab *p;

        p = lookup(varName);
        if(p == NULL){
                install(varName, targType);
        }
}

char* typeToString(enum type_enum type) {
    switch (type) {
        case I64: return "I64";
        case F64: return "F64";
        default: return "ERROR: UNKNOWN TYPE.\n";
    }
}

void printfSymbolTable() {
    struct symtab *p;

    for (int i = 0; i < nsyms; i++) {
            p = &symbols[i];
            printf("%s [%s]\n", p->id ,typeToString(p->type));
    }
}