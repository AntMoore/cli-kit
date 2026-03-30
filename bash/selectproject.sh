#!/bin/bash

# selectproject
# Displays a numbered list of project directories and changes into the selected one.
#
# Usage:
#   selectproject
selectproject() {
    # Resolve this script's directory so config can be sourced reliably even when
    # the command is invoked from a different working directory.
    SCRIPT_DIR=$(dirname "$(realpath "$BASH_SOURCE")")

    # Load shared configuration values (including PROJECTS_PATH).
    source "$SCRIPT_DIR/../config"

    # ANSI color codes used for readable output in terminals that support color.
    RED="\e[0;31m"
    GREEN="\e[1;32m"
    YELLOW="\e[1;33m"
    BLUE="\e[1;34m"
    BOLD="\e[1m"
    RESET="\e[0m"

    # Use the projects folder from config as the target directory.
    local target_dir=$PROJECTS_PATH

    # Guard clause: fail fast if the resolved directory does not exist.
    if [[ ! -d "$target_dir" ]]; then
        echo -e "${RED}Error:${RESET} target directory does not exist: ${YELLOW}$target_dir${RESET}"
        return 1
    fi

    # Build a sorted list of immediate child directories only.
    # - "$target_dir"/*/ matches direct folders under target_dir
    # - basename strips full paths to just folder names
    # - mapfile loads results into the 'projects' Bash array
    mapfile -t projects < <(
        for path in "$target_dir"/*/; do
            [[ -d "$path" ]] && basename "${path%/}"
        done | sort
    )

    # Stop if there are no selectable project folders.
    if [[ ${#projects[@]} -eq 0 ]]; then
        echo -e "${YELLOW}No projects found in:${RESET} $target_dir"
        return 1
    fi

    # Calculate the length of the longest project name so the separator
    # scales to fit the content rather than using a hardcoded width.
    local max_len=0
    for project in "${projects[@]}"; do
        (( ${#project} > max_len )) && max_len=${#project}
    done
    # Add 5 to account for the "[n] " prefix (up to 3 digits + bracket + space).
    local separator
    separator=$(printf '%*s' $(( max_len + 5 )) '' | tr ' ' '-')

    # Print menu header with project count and location context.
    echo ""
    echo -e "${GREEN}Select a project${RESET} ${YELLOW}(${#projects[@]} found)${RESET}"
    echo -e "${BLUE}Location:${RESET} $target_dir"
    echo -e "$separator"

    # Render a 1-based menu in [n] format with bold project names.
    local i=1
    for project in "${projects[@]}"; do
        printf "${BLUE}[%s]${RESET} ${BOLD}%s${RESET}\n" "$i" "$project"
        ((i++))
    done

    echo -e "$separator"

    # Read user choice from stdin. Accept either a number or q/Q to cancel.
    local choice
    echo ""
    read -r -p "Choose project [1-${#projects[@]}] (or q to cancel): " choice

    # User canceled intentionally.
    if [[ "$choice" == "q" || "$choice" == "Q" ]]; then
        echo -e "${YELLOW}Cancelled.${RESET}"
        return 0
    fi

    # Input must be an integer.
    if ! [[ "$choice" =~ ^[0-9]+$ ]]; then
        echo -e "${RED}Invalid selection.${RESET} Enter a number from 1 to ${#projects[@]}."
        return 1
    fi

    # Input must be within the valid menu range.
    if (( choice < 1 || choice > ${#projects[@]} )); then
        echo -e "${RED}Invalid selection.${RESET} Enter a number from 1 to ${#projects[@]}."
        return 1
    fi

    # Convert from 1-based user selection to 0-based array index and cd.
    # If cd fails, propagate failure to caller by returning non-zero.
    local selected="${projects[$((choice - 1))]}"
    cd "$target_dir/$selected" || return 1
    echo -e "\n${GREEN}Now in:${RESET} ${BOLD}${selected}${RESET}"
}

# Primary short alias for convenience.
alias sp="selectproject"

# Backward-compatible aliases for earlier naming.
alias goproject="selectproject"
alias gpj="selectproject"
