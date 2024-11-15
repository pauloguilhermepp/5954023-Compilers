#include <stdarg.h>
#include <stdio.h>
#include <stdlib.h>
#include "types.h"

static struct symtab symbols[MAXSYMS];
static int nsyms = 0;

int yydebug = 1;

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