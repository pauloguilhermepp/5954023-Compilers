# 5954023 - Compilers

## Introduction
This repository contains the final project developed for the class *5954023 - Compilers*. The project description is provided in the file *ProjectDescription.pdf*.

## Collaborators
This project was developed by:
* Paulo Guilherme Pinheiro Pereira - USP Number: 12542755

## Project Description
Below is a list describing the main files and directories in this repository:

```
root/

├── main.sh: Simple bash script to execute the project.
|
├── test.sh: Script used to execute all tests.
|
├── ProjectDescription.pdf: Project description.
|
├── src
|
|   ├── stack.h: Stack struct implemented to track variable scope.
|
|   ├── standard.h: Set of general methods used in the project.
|
|   ├── types.h: Definitions of enums and structs used in the project.
|
|   ├── xyz.l: Lexical analyzer.
|
|   ├── xyz.y: Syntax analyzer.
|
|   ├── tests: Set of tests developed to validate the tool.
|
├── tests
|
|   ├── results: Expected results of the tests.
|
|   ├── scripts: Set of xyz files to test the tool.
```

## Running the Project
In a Linux environment, you can execute the tool by running:

```
bash main.sh <input_file_path>
```

It is also possible to execute all tests presented here by running:

```
bash tests.sh
```

## Observations
Considering the exercises given in the pdf file:

**1.** Lexical analyzer is presented at *src/xyz.l*.

**2.** Syntax analyzer is presented at *src/xyz.y*.

**3.** Symbol table is properly displayed and can be checked to the *fat.xyz* example by running:

```
bash main.sh tests/scripts/fat.xyz
```
with a return equal to the expected:
```
fatorial.n [i64]
fatorial.i [i64]
fatorial.r [i64]
main.i [i64]
main.f [i64]
```

**4.** To detect if a variable already was declared when its value is used, we make a search in the Symbol Table for a variable with the same name and scope of the variable that we are currently using. If we find a match, we know that this variable was properly declared. If this is not the case, it means that it was not declared.