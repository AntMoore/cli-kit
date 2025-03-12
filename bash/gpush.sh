#!/bin/bash

gpush() {
    local bluetext="\e[1;34m"
    local yellowtext="\e[1;33m"
    local resettext="\e[0m"

    # Check if there is an upstream branch
    local branch_name=$(git branch --show-current)

    if git rev-parse --abbrev-ref --symbolic-full-name @{u} > /dev/null 2>&1; then
        echo -e "${bluetext}Upstream branch found, pushing${resettext}"
        echo

        git push
    else
        echo -e "${yellowtext}No upstream branch found, setting upstream${resettext}"
        echo

        git push --set-upstream origin "$branch_name"
    fi
}
