#!/bin/bash

gosln() {
    if [[ "$1" == "-a" || "$1" == "--all" ]]; then
        echo "Opening all .sln files, including nested ones"

        # Find and open all .sln files recursively
        find . -type f -name "*.sln" | while read -r sln_file; do
            echo "Opening $sln_file"

            start "$sln_file"
        done
    else
        echo "Opening the first .sln file found"

        # Find and open the first .sln file
        first_sln=$(find . -type f -name "*.sln" | head -n 1)
        if [[ -n "$first_sln" ]]; then
            echo "Opening $first_sln"

            start "$first_sln"
        else
            echo "No .sln files found."
        fi
    fi
}

alias sln="gosln"