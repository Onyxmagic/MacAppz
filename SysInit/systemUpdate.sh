#!/bin/zsh

#  ██████   █████   █████████  █████ ███████████
# ░░██████ ░░███   ███░░░░░███░░███ ░█░░░███░░░█
#  ░███░███ ░███  ███     ░░░  ░███ ░   ░███  ░ 
#  ░███░░███░███ ░███          ░███     ░███    
#  ░███ ░░██████ ░███          ░███     ░███    
#  ░███  ░░█████ ░░███     ███ ░███     ░███    
#  █████  ░░█████ ░░█████████  █████    █████   
#  ░░░░░    ░░░░░   ░░░░░░░░░  ░░░░░    ░░░░░   

# <------------------------------------------>
# | MacOS System updater from command line  |
# | Bendahon 2025                           |
# | This script correctly parses the        |
# | multi-line output of `softwareupdate -l`|
# | to find the highest version number,     |
# | then installs by its label.             |
# | Run with sudo: sudo systemUpdate        |
# | V1.0 - initial release                  |
# | V1.1 - Added jump to latest             |
# <----------------------------------------->


echo "Finding available macOS updates..."

# This awk script processes the multi-line output from softwareupdate.
# 1. Sets the Record Separator (RS) to "\* Label: ". This treats each update as a block.
#    (The "*" must be escaped with \\ as it's a special regex character)
# 2. Filters for blocks that contain "macOS" and "Version:".
# 3. Extracts the label from the first line (sub) and the version from the "Version: " field.
# 4. Prints the version and label, separated by a "|||" marker.
SORTED_LIST=$(softwareupdate -l | awk '
BEGIN { RS = "\\* Label: " }
/macOS/ && /Version:/ {
    # Get the label from the first line of the record
    label = $0
    sub(/\n.*/, "", label)
    gsub(/^[ \t]+|[ \t]+$/, "", label) # Trim whitespace

    # Get the version from the "Version: " field
    version = $0
    sub(/.*Version: /, "", version)
    sub(/,.*/, "", version)
    
    print version, "|||", label
}
')

if [[ -z "$SORTED_LIST" ]]; then
    echo "No new 'macOS' labeled updates were found."
    exit 0
fi

# At this point, SORTED_LIST looks like:
# 15.7.1 ||| macOS Sequoia 15.7.1-24G231
# 26.0.1 ||| macOS Tahoe 26.0.1-25A362

# 5. Sort this list by version and grab the last one
LATEST_LINE=$(echo "$SORTED_LIST" | sort -V | tail -n 1)

# 6. Extract just the label part, using "|||" as the delimiter
#    -F ' \\|\\|\\| ' -> Sets the field separator to " ||| "
#    '{print $2}'      -> Prints the second field (the label)
LATEST_LABEL=$(echo "$LATEST_LINE" | awk -F ' \\|\\|\\| ' '{print $2}')

if [[ -z "$LATEST_LABEL" ]]; then
    echo "Could not parse the update label. Exiting."
    echo "Debug Info: $LATEST_LINE"
    exit 1
fi

echo "Latest OS update found: $LATEST_LINE"
echo "Extracted label to install: \"$LATEST_LABEL\""
echo "Starting the installation. This will require a reboot."
echo "Press enter to start"
read

# 7. Install
sudo softwareupdate --install "$LATEST_LABEL" --restart --agree-to-license --force  --verbose
