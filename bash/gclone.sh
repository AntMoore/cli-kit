#!/bin/bash

gclone() {
    # Check if no arguments are provided
    if [[ $# -eq 0 ]]; then
        echo "Usage: gclone <repository-url>"
        return 1
    fi

    # Navigate to the projects folder before trying to clone
    echo "Navigating to projects folder"
    echo
    gotoprojects

    local BLUE="\e[1;34m"
    local YELLOW="\e[1;33m"
    local RESET="\e[0m"

    # Handle --help or -h flag
    if [[ "$1" == "--help" || "$1" == "-h" ]]; then
        echo "Usage: gclone <repository-url>"
        echo "Clones a Git repository and automatically enters the cloned directory."
        echo
        echo "Options:"
        echo "  -h, --help     Show this help message"
        return 0
    fi

    local repo_name="$(basename "$1" .git)"

    if [[ -d "$repo_name" ]]; then
        echo -e ${YELLOW}"Repo already exists, navigating to folder"${RESET}
        echo

        cd "$(basename "$1" .git)"
    else
        echo -e ${BLUE}"Cloning the repo down, and navigating to folder"${RESET}
        echo

        # Clone the repository and cd into it
        git clone "$1" && cd "$(basename "$1" .git)"
    fi

}