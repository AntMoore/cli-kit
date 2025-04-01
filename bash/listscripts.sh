#!/bin/bash

listscripts() {
    SCRIPT_DIR=$(dirname "$(realpath "$BASH_SOURCE")")
    MANIFEST="$SCRIPT_DIR/../manifest.json"

    # ANSI color codes
    RED="\e[0;31m"
    GREEN="\e[1;32m"
    YELLOW="\e[1;33m"
    BLUE="\e[1;34m"
    RESET="\e[0m"

    if [[ ! -f "$MANIFEST" ]]; then
        echo -e "${RED}Error: manifest (${MANIFEST}) not found${RESET}"
        return 1
    fi

    echo ""
    echo -e "${GREEN}Available CLI Scripts:${RESET}"
    echo "-----------------------"

    # Extract scripts from JSON (Fix: Using `###` as a separator)
    jq -r '.scripts[] | "\(.command)#\(.description)#\(.aliases // [] | join(", "))"' "$MANIFEST" | tr -d '\r' | while IFS='#' read -r command desc aliases; do
        # echo "DEBUG: command='$command' desc='$desc' aliases='$aliases'"  # Debugging line
        
        if [[ -n "$command" && -n "$desc" ]]; then
            if [[ -n "$aliases" ]]; then
                echo -e "- ${BLUE}${command}${RESET} (${YELLOW}${aliases}${RESET}): ${desc}"
            else
                echo -e "- ${BLUE}${command}${RESET}: ${desc}"
            fi
        fi
    done
}

# Create an alias for listscripts()
alias lcs="listscripts"