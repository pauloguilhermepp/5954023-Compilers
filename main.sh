#!/bin/bash

if [ -z "$2" ]; then
  echo "Error: Input does not follow standards."
  echo "Usage: $0 <project_path> <input_file_path>"
  exit 1
fi

PROJECT_PATH=$1
INPUT_FILE_PATH=$2

lex -o ${PROJECT_PATH}.yy.c ${PROJECT_PATH}.l
bison -d -o ${PROJECT_PATH}.tab.c ${PROJECT_PATH}.y
gcc -o ${PROJECT_PATH} ${PROJECT_PATH}.tab.c

./${PROJECT_PATH} ${INPUT_FILE_PATH}
