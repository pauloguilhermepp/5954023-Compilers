#ifndef __XYZ_TYPES_H__
#define __XYZ_TYPES_H__

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
        char scope[MAXTOKEN];
        struct typed_value tval;
};

extern void assign(char *id, enum type_enum targTyp, struct typed_value tval);
extern int yyerror (char const *msg, ...);
extern int yylex();

extern struct symtab *lookup(char *id);

#endif