#!/bin/bash

# Get the directory of the script itself
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

while true; do
    # Prompt the user for input
    echo -n "Enter input: " >&1
    read user_input

    # Check if the input is 'deadbeef'
    if [[ "$user_input" == "deadbeef" ]]; then
        flag_path="$SCRIPT_DIR/flag.txt"
        if [[ -f "$flag_path" ]]; then
            cat "$flag_path"
        else
            echo "Error: flag.txt not found in script directory."
        fi
    else
        echo "You entered: $user_input"
    fi
done
