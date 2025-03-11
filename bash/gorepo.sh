#!/bin/bash

gorepo() {
    local redtext="\e[0;31m"
    local bluetext="\e[1;34m"
    local yellowtext="\e[1;33m"
    local resettext="\e[0m"

    local repo_url=$(git config --get remote.origin.url)
    local branch_flag=false

    # Parse command-line arguments
    for arg in "$@"; do
        if [[ "$arg" == "-cb" || "$arg" == "--current-branch" ]]; then
            branch_flag=true
        fi
    done

    # Check if the current directory is a git repository
    if [ -z "$repo_url" ]; then
        echo -e ${redtext}"Not a git repository or no remote origin set."${resettext}
        echo
        exit 1
    fi

    # Convert SSH URLs to HTTPS if needed
    if [[ $repo_url == git@* ]]; then
        repo_url=$(echo "$repo_url" | sed -E 's/git@([^:]+):([^ ]+).git/https:\/\/\1\/\2/')
    else
        # Remove trailing .git from HTTPS URLs
        repo_url=$(echo "$repo_url" | sed 's/\.git$//')
    fi

    # If the flag is set, check if the current branch exists on the remote
    if [ "$branch_flag" = true ]; then
        local branch_name=$(git branch --show-current)

        if [ -n "$branch_name" ]; then
            local remote_branch_exists=$(git ls-remote --heads origin "$branch_name")

            if [ -n "$remote_branch_exists" ]; then
                repo_url="$repo_url/tree/$branch_name"
            else
                echo -e "${yellowtext}Warning: The current branch '$branch_name' is not found on the remote. Opening the main repository page instead.${resettext}"
                echo
            fi
        fi
    fi

    echo -e "${bluetext}Navigating to: $repo_url${resettext}"
    echo

    start "$repo_url"
}

alias gogit="gorepo"
alias gogithub="gorepo"