#!/bin/bash

if [ -z "$1" ]; then
  echo "Error: Input does not follow standards."
  echo "Usage: $0 <input_file_path>"
  exit 1
fi

INPUT_FILE_PATH=$1

lex -o src/xyz.yy.c src/xyz.l
bison -d -o src/xyz.tab.c src/xyz.y
gcc -o src/xyz src/xyz.tab.c

./src/xyz ${INPUT_FILE_PATH}
