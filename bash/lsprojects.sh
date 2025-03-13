#!/bin/bash

lsprojects() {
    SCRIPT_DIR=$(dirname "$(realpath "$BASH_SOURCE")")
    source "$SCRIPT_DIR/../config"

    ls "$PROJECTS_PATH" $1
}

# Create an alias for gotoprojects()
alias lsp="lsprojects"