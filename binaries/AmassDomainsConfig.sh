#!/bin/bash

# Define paths for the original and new configuration files.
ORIGINAL_CONFIG_FILE="/root/osmedeus-base/data/amass-config/basic-config.yaml"
NEW_CONFIG_FILE="/root/osmedeus-base/data/amass-config/basic-config-custom.yaml"

# Check if the original configuration file exists.
if [ ! -f "$ORIGINAL_CONFIG_FILE" ]; then
    echo "The file $ORIGINAL_CONFIG_FILE does not exist."
    exit 1
fi

# Copy the original configuration file to a new file.
cp "$ORIGINAL_CONFIG_FILE" "$NEW_CONFIG_FILE"

# Read each line from /tmp/domains.txt and append it under the 'domains' section in basic-config-custom.yaml
while IFS= read -r domain; do
    # Use sed to find the 'domains:' line and append the domain in the correct format
    sed -i "/domains:/a \ \ \ - $domain" $NEW_CONFIG_FILE
done < $1
