#!/bin/bash

goslnx() {
    if [[ "$1" == "-a" || "$1" == "--all" ]]; then
        echo "Opening all .slnx files, including nested ones"

        # Find and open all .slnx files recursively
        find . -type f -name "*.slnx" | while read -r slnx_file; do
            echo "Opening $slnx_file"

            start "$slnx_file"
        done
    else
        echo "Opening the first .slnx file found"

        # Find and open the first .slnx file
        first_slnx=$(find . -type f -name "*.slnx" | head -n 1)
        if [[ -n "$first_slnx" ]]; then
            echo "Opening $first_slnx"

            start "$first_slnx"
        else
            echo "No .slnx files found."
        fi
    fi
}

alias slnx="goslnx"