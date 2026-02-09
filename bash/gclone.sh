#!/bin/bash

gclone() {
    # Check if no arguments are provided
    if [[ $# -eq 0 ]]; then
        echo "Usage: gclone [-b|--basic] <repository-url|repository-name>"
        return 1
    fi

    # Navigate to the projects folder before trying to clone
    # echo "Navigating to projects folder"
    # echo
    # gotoprojects

    local BLUE="\e[1;34m"
    local YELLOW="\e[1;33m"
    local RESET="\e[0m"

    # Handle --help or -h flag
    if [[ "$1" == "--help" || "$1" == "-h" ]]; then
        echo "Usage: gclone [-b|--basic] <repository-url|repository-name>"
        echo "Clones a Git repository and automatically enters the cloned directory."
        echo
        echo "Options:"
        echo "  -h, --help     Show this help message"
        echo "  -b, --basic    Provide only the repository name (e.g., 'repo-name')"
        return 0
    fi

    local repo_url="$1"

    # Handle -b or --basic flag
    if [[ "$1" == "-b" || "$1" == "--basic" ]]; then
        if [[ -z "$2" ]]; then
            echo "Error: Repository name is required when using -b or --basic flag."
            return 1
        fi
        repo_url="https://github.com/finova-mso/$2.git"
    fi

    local repo_name="$(basename "$repo_url" .git)"

    if [[ -d "$repo_name" ]]; then
        echo -e ${YELLOW}"Repo already exists, navigating to folder"${RESET}
        echo

        cd "$repo_name"
    else
        echo -e ${BLUE}"Cloning the repo down, and navigating to folder"${RESET}
        echo

        git clone "$repo_url" && cd "$repo_name"
    fi
}