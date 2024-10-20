#!/bin/bash

if [ -z "$1" ]; then
  echo "Error: No file name provided."
  echo "Usage: $0 <file_name>"
  exit 1
fi

FILE=$1

lex -o ${FILE}.yy.c ${FILE}.l
bison -d -o ${FILE}.tab.c ${FILE}.y
gcc ${FILE}.yy.c ${FILE}.tab.c -o ${FILE} -ll

./${FILE}
