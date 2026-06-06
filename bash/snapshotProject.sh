#!/bin/bash

snapshotProject() {
    local script_dir
    local folder_name
    local date_stamp
    local output_name
    local output_path
    local output_dir
    local zip_file_name
    local default_output_dir
    local custom_output=false

    # Folders commonly not useful for AI code reviews.
    local exclude_dirs=(
        ".git"
        ".vs"
        ".vscode"
        ".idea"
        "node_modules"
        "bin"
        "obj"
        "dist"
        "build"
        "out"
        "coverage"
        ".next"
        ".nuxt"
        "target"
        ".cache"
    )

    folder_name="$(basename "$PWD")"
    date_stamp="$(date +%Y%m%d)"
    output_name="${folder_name}-${date_stamp}.zip"

    while [[ $# -gt 0 ]]; do
        case "$1" in
            -h|--help)
                echo "Usage: snapshotProject [-o|--output <zip-file-name-or-path>]"
                echo "Creates a shareable project snapshot of the current folder."
                echo
                echo "Default output: <PROJECTS_PATH>/ProjectZips/<current-folder>-<yyyMMdd>.zip"
                echo
                echo "Options:"
                echo "  -h, --help      Show this help message"
                echo "  -o, --output    Custom output zip file name or path"
                return 0
                ;;
            -o|--output)
                if [[ -z "$2" ]]; then
                    echo "Error: Missing value for $1"
                    return 1
                fi
                output_name="$2"
                custom_output=true
                shift
                ;;
            *)
                echo "Error: Unknown option '$1'"
                echo "Run 'snapshotProject --help' for usage."
                return 1
                ;;
        esac
        shift
    done

    if [[ "$output_name" != *.zip ]]; then
        output_name="${output_name}.zip"
    fi

    if [[ "$custom_output" == true ]]; then
        if [[ "$output_name" == /* || "$output_name" =~ ^[A-Za-z]:[\\/] ]]; then
            output_path="$output_name"
        else
            output_path="$PWD/$output_name"
        fi
    else
        script_dir=$(dirname "$(realpath "$BASH_SOURCE")")
        source "$script_dir/../config"

        default_output_dir="$PROJECTS_PATH/ProjectZips"
        output_path="$default_output_dir/$output_name"
    fi

    output_dir="$(dirname "$output_path")"
    mkdir -p "$output_dir"

    zip_file_name="$(basename "$output_path")"
    if ! command -v zip > /dev/null 2>&1; then
        echo "Error: 'zip' is required but was not found."
        return 1
    fi

    if ! (
        cd "$PWD" &&
        rm -f "$output_path" &&
        zip -r -q "$output_path" . \
            -x "*/.git/*" \
               "*/.vs/*" \
               "*/.vscode/*" \
               "*/.idea/*" \
               "*/node_modules/*" \
               "*/bin/*" \
               "*/obj/*" \
               "*/dist/*" \
               "*/build/*" \
               "*/out/*" \
               "*/coverage/*" \
               "*/.next/*" \
               "*/.nuxt/*" \
               "*/target/*" \
               "*/.cache/*" \
               "*.zip" \
               "$zip_file_name"
    ); then
        echo "Error: Failed to create zip package."
        return 1
    fi

    echo "Created: $output_path"
}

alias snapproj="snapshotProject"