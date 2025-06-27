#!/bin/bash

#  ██████   █████   █████████  █████ ███████████
# ░░██████ ░░███   ███░░░░░███░░███ ░█░░░███░░░█
#  ░███░███ ░███  ███     ░░░  ░███ ░   ░███  ░ 
#  ░███░░███░███ ░███          ░███     ░███    
#  ░███ ░░██████ ░███          ░███     ░███    
#  ░███  ░░█████ ░░███     ███ ░███     ░███    
#  █████  ░░█████ ░░█████████  █████    █████   
#  ░░░░░    ░░░░░   ░░░░░░░░░  ░░░░░    ░░░░░    

# <--------------------------->
# | Set the PC Name with flag |
# | Bendahon 2025             |
# | So give it allllll        |
# | V1.0                      |
# <--------------------------->

# Eventually I want this just to run with prepareForShutdown.sh

# Define the path to the file that holds the desired computer name
PCNAME_FILE="/etc/ncadmin/pcname"
sudo mkdir -p /etc/ncadmin

echo "Checking for predefined computer name file: $PCNAME_FILE"

# Check if the file exists and is readable
if [[ -f "$PCNAME_FILE" && -r "$PCNAME_FILE" ]]; then
    # Read the desired name from the file, trim leading/trailing whitespace
    DESIRED_NAME=$(<"$PCNAME_FILE" tr -d '\n' | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')

    if [[ -z "$DESIRED_NAME" ]]; then
        echo "Error: Predefined name file is empty. Will ask for input."
        read -p "Enter the new computer name (e.g., [Music]Mac Lab 01): " NEW_COMPUTER_NAME
    else
        echo "Predefined computer name found: \"$DESIRED_NAME\""
        NEW_COMPUTER_NAME="$DESIRED_NAME"
    fi
else
    echo "Predefined computer name file not found or not readable. Will ask for input."
    read -p "Enter the new computer name (e.g., [Music]Mac Lab 01): " NEW_COMPUTER_NAME
fi

# Check if a name was provided (either from file or user input)
if [[ -z "$NEW_COMPUTER_NAME" ]]; then
    echo "No computer name provided. Exiting."
    exit 1
fi

echo "Attempting to set computer name to: \"$NEW_COMPUTER_NAME\""

# Set the Computer Name (user-friendly name)
sudo scutil --set ComputerName "$NEW_COMPUTER_NAME"
if [ $? -eq 0 ]; then
    echo "Successfully set Computer Name."
else
    echo "Failed to set Computer Name."
fi

# Set the Local Hostname (Bonjour name) - often derived from ComputerName
# This converts spaces to hyphens and makes it lowercase
LOCAL_HOSTNAME=$(echo "$NEW_COMPUTER_NAME" | tr ' ' '-' | tr '[:upper:]' '[:lower:]')
# Remove any characters that are not alphanumeric or hyphens
LOCAL_HOSTNAME=$(echo "$LOCAL_HOSTNAME" | sed 's/[^a-zA-Z0-9-]//g')
# Limit to 63 characters for hostname conventions
LOCAL_HOSTNAME="${LOCAL_HOSTNAME:0:63}"

sudo scutil --set LocalHostName "$LOCAL_HOSTNAME"
if [ $? -eq 0 ]; then
    echo "Successfully set Local Hostname to: \"$LOCAL_HOSTNAME\""
else
    echo "Failed to set Local Hostname."
fi

# Optionally, set the HostName (DNS hostname) - usually the same as LocalHostName
sudo scutil --set HostName "$LOCAL_HOSTNAME"
if [ $? -eq 0 ]; then
    echo "Successfully set HostName to: \"$LOCAL_HOSTNAME\""
else
    echo "Failed to set HostName."
fi

echo ""
echo "Current computer names after update:"
echo "Computer Name: $(scutil --get ComputerName)"
echo "Local Hostname: $(scutil --get LocalHostName)"
echo "HostName: $(scutil --get HostName)"

echo ""
echo "You can verify this in System Settings > General > About."