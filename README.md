# cli-kit
A collection of useful CLI commands for various scenarios, built for Windows machines.

## Requirements

In order to implement these scripts as suggested in [Loading the scripts](#loading-the-scripts), and to run some of the scripts themselves, you will require the [jq package](https://jqlang.org/). 

## Available scripts
| **Name**                     | **Command**    | **Aliases**     | **Flags**  | **Description**                                                                 | **Location**           |
|------------------------------|----------------|-----------------|------------|---------------------------------------------------------------------------------|------------------------|
| List available scripts       | listscripts    | lcs             |            | Displays all available CLI scripts in the manifest                              | [bash/listscripts.sh](./bash/listscripts.sh) |
| Reload scripts               | reloadscripts  |                 |            | Shorthand for 'source ~/.bashrc'                                                | [bash/reloadscripts.sh](./bash/reloadscripts.sh) |
| Git clone and enter directory| gclone         |                 | -h, --help, -b, --basic | ~~Navigates to the projects folder (see Go to projects),~~ then clones a git project using a git URL or a repository name (with -b/--basic flag) and then navigates into newly created directory | [bash/gclone.sh](./bash/gclone.sh) |
| Git push (with upstream setting)| gpush       |                 |            | Will check if there's an upstream branch that matches current branch, calls 'git push' if upstream exists, creates it if it doesn't | [bash/gpush.sh](./bash/gpush.sh) |
| Git submodule update         | gsubup         |                 |            | Will update git submodules recursively                                          | [bash/gsubup.sh](./bash/gsubup.sh) |
| Go to repo                   | gorepo         | gogit, gogithub |            | Opens the GitHub repo in the default browser. Use '-cb' or '--current-branch' to open the current branch if it exists remotely. | [bash/gorepo.sh](./bash/gorepo.sh) |
| Go to projects               | gotoprojects   | gtp             |            | Navigates to the projects folder, defined by the PROJECTS_PATH variable in config file | [bash/gotoprojects.sh](./bash/gotoprojects.sh) |
| List projects                | lsprojects     | lsp             |            | Lists folders in projects, accepts all flags provided by `ls` command           | [bash/lsprojects.sh](./bash/lsprojects.sh) |
| Go sln                       | gosln          | sln             | -a, --all | Opens the first .sln file it finds by default, or all .sln files (including nested ones) when using the -a/--all flag | [bash/gosln.sh](./bash/gosln.sh) |
| Playground                   | goplay         |                 |            | A place to test scripts                                                         | [bash/playground.sh](./bash/playground.sh) |

## Loading the scripts
If you enter the below script into `~/.bashrc`, then it will auto load these scripts from the manifest.json, using the location property

```shell
# START custom script loading
CLI_KIT_DIR="<PATH_TO_THIS_REPO>" #e.g. /c/user/dev/cli-kit

while IFS= read -r script_path; do
    script_path=$(echo "$script_path" | tr -d '\r')  # Remove ^M characters
    full_path="$CLI_KIT_DIR/$script_path"
    
    if [[ -f "$full_path" ]]; then
        source "$full_path"
    else
        echo "ERROR: File not found - $full_path"
    fi
done < <(jq -r '.scripts[].location' "$CLI_KIT_DIR/manifest.json" | tr -d '\r')
# END custom script loading
```

After updating the `~/.bashrc` file, you will need to reload your shell window. Run `lcs` to show the list of available scripts provided by this package.

## Config file
The `config` file contains key configuration settings, such as the `PROJECTS_PATH`, which defines the directory for your development projects. This allows scripts to dynamically reference the path, making the setup flexible and easily customizable across different environments.