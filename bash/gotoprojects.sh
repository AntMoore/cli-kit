#!/bin/bash

gotoprojects() {
    SCRIPT_DIR=$(dirname "$(realpath "$BASH_SOURCE")")
    source "$SCRIPT_DIR/../config"

    local target_dir=$PROJECTS_PATH

    OPTIND=1 # Ensure we're starting at the start of args

    while getopts "c:" arg; do
        case $arg in
            c) target_dir="$PROJECTS_PATH/clients/$OPTARG";;
        esac
    done

    cd "$target_dir"
}

# Create an alias for gotoprojects()
alias gtp="gotoprojects"