#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAX 100

typedef struct {
    char *elements[MAX];
    int top;
} Stack;

void push(Stack *s, const char *c) {
    if (s->top == MAX - 1) {
        printf("Stack overflow\n");
        return;
    }
    s->top++;
    s->elements[s->top] = strdup(c);
}

char *pop(Stack *s) {
    if (s->top == -1) {
        printf("Stack underflow\n");
        return NULL;
    }
    char *popped = s->elements[s->top];
    s->top--;
    return popped;
}

char *getStack(Stack *s) {
    if (s->top == -1) {
        return strdup("");
    }

    size_t totalLength = 0;
    for (int i = 0; i <= s->top; i++) {
        totalLength += strlen(s->elements[i]) + 1;
    }

    char *result = (char *)malloc(totalLength);

    result[0] = '\0';
    for (int i = 0; i <= s->top; i++) {
        strcat(result, s->elements[i]);
        if (i <= s->top) {
            strcat(result, ".");
        }
    }

    return result;
}

void printStack(const Stack *s) {
    for (int i = 0; i <= s->top; i++) {
        printf("%s", s->elements[i]);
        if (i < s->top) {
            printf(".");
        }
    }
    printf("\n");
}

void freeStack(Stack *s) {
    while (s->top != -1) {
        free(s->elements[s->top]);
        s->top--;
    }
}
