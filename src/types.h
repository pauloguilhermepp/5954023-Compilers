#ifndef __XYZ_TYPES_H__
#define __XYZ_TYPES_H__

#include "stack.h"

#define MAXTOKEN 64
#define MAXSYMS 256

enum type_enum {
        I64, F64
};

struct symtab {
        char id[MAXTOKEN];
        enum type_enum typ;
};

Stack scopeStack = {.top = -1};

int yydebug = 1;
static int nsyms = 0;
static struct symtab symbols[MAXSYMS];

extern int yylex();
#endif