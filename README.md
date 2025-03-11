# cli-kit
A collection of useful CLI commands for various scenarios

## Available scripts
| **Name**                     | **Command**       | **Aliases**     | **Flags**       | **Description**                                                                 | **Location**           |
|------------------------------|-------------------|-----------------|-----------------|---------------------------------------------------------------------------------|------------------------|
| List available scripts       | listscripts       | lcs             |                 | Displays all available CLI scripts in the manifest                              | bash/listscripts.sh    |
| Reload scripts               | reloadscripts     |                 |                 | Shorthand for 'source ~/.bashrc'                                                | bash/reloadscripts.sh  |
| Git clone and enter directory| gclone            |                 | -h, --help      | Navigates to the projects folder (see Go to projects), then clones a git project using a git URL and then navigates into newly created directory | bash/gclone.sh         |
| Go to projects               | gotoprojects      | gtp             |                 | Navigates to the projects folder, defined by the PROJECTS_PATH variable in config file | bash/gotoprojects.sh   |
| Go sln                       | gosln             | sln             |                 | Shorthand for 'start *.sln'                                                     | bash/gosln.sh          |
| Playground                   | goplay            |                 |                 | A place to test scripts                                                         | bash/playground.sh     |

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

## Config file
The `config` file contains key configuration settings, such as the `PROJECTS_PATH`, which defines the directory for your development projects. This allows scripts to dynamically reference the path, making the setup flexible and easily customizable across different environments.