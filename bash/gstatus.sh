#!/bin/bash

gstatus() {
    local bluetext="\e[1;34m"
    local yellowtext="\e[1;33m"
    local redtext="\e[0;31m"
    local resettext="\e[0m"

    # Check if the current directory is a Git repository
    if ! git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
        echo -e "${redtext}Error: Not a Git repository.${resettext}"
        return 1
    fi

    # Display the current branch
    local branch_name=$(git branch --show-current)
    echo -e "${bluetext}Current branch:${resettext} ${branch_name}"

    # Check for untracked files
    local untracked_files=$(git ls-files --others --exclude-standard)
    if [[ -n "$untracked_files" ]]; then
        echo -e "${yellowtext}Untracked files:${resettext}"
        echo "$untracked_files"
    else
        echo -e "${bluetext}No untracked files.${resettext}"
    fi

    # Check for changes in the working directory
    local changes=$(git status --short)
    if [[ -n "$changes" ]]; then
        echo -e "${yellowtext}Changes:${resettext}"
        echo "$changes"
    else
        echo -e "${bluetext}No changes.${resettext}"
    fi

    # Check if the branch is ahead/behind the remote
    local upstream_status=$(git status -sb | grep "\[" | sed 's/## //')
    if [[ -n "$upstream_status" ]]; then
        echo -e "${yellowtext}Upstream status:${resettext} ${upstream_status}"
    else
        echo -e "${bluetext}Branch is up-to-date with remote.${resettext}"
    fi
}

alias gst="gstatus"