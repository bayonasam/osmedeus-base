#!/bin/bash

# Script Description:
# This script is designed to be executed within an Osmedeus YAML configuration file prior to running Amass.
# It automates the process of updating the Amass configuration file with environment variable values. 
# Specifically, it copies the original datasources.yaml to datasources_token.yaml, then
# scans through all environment variables. For each variable, if its name is found in datasources_token.yaml, the script
# replaces occurrences of that variable name in the file with its corresponding value from the environment. This ensures
# that Amass is executed with the current API tokens and settings defined in the environment.

# Define paths for the original and new datasources files.
ORIGINAL_CONFIG_FILE="/root/osmedeus-base/data/amass-config/datasources.yaml"
NEW_CONFIG_FILE="/root/osmedeus-base/data/amass-config/datasources_token.yaml"

# Check if the original configuration file exists.
if [ ! -f "$ORIGINAL_CONFIG_FILE" ]; then
    echo "The file $ORIGINAL_CONFIG_FILE does not exist."
    exit 1
fi

# Copy the original configuration file to a new file.
cp "$ORIGINAL_CONFIG_FILE" "$NEW_CONFIG_FILE"

# Read and process each environment variable.
while read -r variable_env; do
    # Extract the variable name.
    var_name=$(echo "$variable_env" | cut -d '=' -f 1)

    # Check if the variable name exists in the new configuration file.
    if grep -wq "$var_name" "$NEW_CONFIG_FILE"; then
        # Escape special characters in the variable name.
        escaped_value=$(sed -e 's/[&\\/]/\\&/g; s/$/\\/' -e '$s/\\$//' <<<"$var_name")

        # Get the value of the environment variable.
        var_value=$(printenv "$escaped_value")

        # Replace the variable name in the file with its value.
        sed -i "s/$var_name/$var_value/g" "$NEW_CONFIG_FILE"
    fi      
done < <(env)
