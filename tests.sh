#!/bin/bash

scripts_dir="tests/scripts"
results_dir="tests/results"

for script_file in "$scripts_dir"/*; do
    script_name=$(basename "$script_file")
    
    result_file="$results_dir/$script_name.txt"

    script_output=$(bash main.sh "$script_file" 2>&1)
    
    expected_output=$(cat "$result_file")
    
    if [[ "$script_output" == "$expected_output" ]]; then
        echo -e "\e[32mTest passed for $script_name.\e[0m"
    else
        echo -e "\e[31mTest failed for $script_name."
        echo -e "\e[31mExpected:\e[0m"
        echo "$expected_output"
        echo -e "\e[31mGot:\e[0m"
        echo "$script_output"
    fi
done
