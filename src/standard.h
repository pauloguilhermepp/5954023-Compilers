#include <stdarg.h>
#include <stdio.h>
#include <stdlib.h>
#include "types.h"

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

void printfSymbolTable() {
    struct symtab *p;

    for (int i = 0; i < nsyms; i++) {
            p = &symbols[i];
            if (p->tval.typ == I64){
                printf("%s = %d [I64]\n", p->id, p->tval.val.ival);
            }else {
                printf("%s = %f [F64]\n", p->id, p->tval.val.fval);
            }
    }
}