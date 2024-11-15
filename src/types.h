#ifndef __XYZ_TYPES_H__
#define __XYZ_TYPES_H__

#define MAXTOKEN 64
#define MAXSYMS 256

enum type_enum {
        I64, F64
};

struct symtab {
        char id[MAXTOKEN];
        enum type_enum typ;
};

extern void assign(char *id, enum type_enum targTyp);
extern int yyerror (char const *msg, ...);
extern int yylex();

extern struct symtab *lookup(char *varName);

#endif