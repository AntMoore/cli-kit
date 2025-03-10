# cli-kit
A collection of useful CLI commands for various scenarios

If you enter the below script into `~/.bashrc`, then it will auto load these scripts from the manifest.json, using the location property

```shell
# START custom script loading
CLI_KIT_DIR="/c/Users/Antonio.Moore/Documents/development/projects/cli-kit"

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