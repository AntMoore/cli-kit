#!/bin/bash

gclone() {
    # Check if no arguments are provided
    if [[ $# -eq 0 ]]; then
        echo "Usage: gclone <repository-url>"
        return 1
    fi

    # Handle --help or -h flag
    if [[ "$1" == "--help" || "$1" == "-h" ]]; then
        echo "Usage: gclone <repository-url>"
        echo "Clones a Git repository and automatically enters the cloned directory."
        echo
        echo "Options:"
        echo "  -h, --help     Show this help message"
        return 0
    fi

    # Clone the repository and cd into it
    git clone "$1" && cd "$(basename "$1" .git)"
}