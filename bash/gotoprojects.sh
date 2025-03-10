#!/bin/bash

gotoprojects() {
    SCRIPT_DIR=$(dirname "$(realpath "$BASH_SOURCE")")
    source "$SCRIPT_DIR/../config"

    cd "$PROJECTS_PATH"
}

# Create an alias for gotoprojects()
alias gtp="gotoprojects"