#!/bin/bash


#  ██████   █████   █████████  █████ ███████████
# ░░██████ ░░███   ███░░░░░███░░███ ░█░░░███░░░█
#  ░███░███ ░███  ███     ░░░  ░███ ░   ░███  ░ 
#  ░███░░███░███ ░███          ░███     ░███    
#  ░███ ░░██████ ░███          ░███     ░███    
#  ░███  ░░█████ ░░███     ███ ░███     ░███    
#  █████  ░░█████ ░░█████████  █████    █████   
#  ░░░░░    ░░░░░   ░░░░░░░░░  ░░░░░    ░░░░░    

# <------------------------------------->
# | Delete all users except in the list |
# | for a clean post holiday user exp   |
# | Bendahon 2025                       |
# | Insert song lyrics here             |
# | V1.0                                |
# <------------------------------------->


# Define users to keep
# Add "Guest" and "Shared" to avoid issues with system functionalities.
USERS_TO_KEEP=("root" "ncadmin" "ncadminUI" "daemon" "nobody" "Guest" "Shared") 

echo "Identifying users to delete (excluding: ${USERS_TO_KEEP[*]})"
echo "---------------------------------------------------------"

# Get all user accounts
all_users=$(dscl . list /Users | grep -v '^_.*')

# Make array to show users to delete
users_to_delete=()

# Iterate through all users and identify those not in the "keep" list
for user in $all_users; do
    keep_user=false
    for keep in "${USERS_TO_KEEP[@]}"; do
        if [[ "$user" == "$keep" ]]; then
            keep_user=true
            break
        fi
    done

    if [[ "$keep_user" == "false" ]]; then
        users_to_delete+=("$user")
    fi
done

if [ ${#users_to_delete[@]} -eq 0 ]; then
    echo "No user accounts found to delete."
    exit 0
fi

echo ""
echo "The following user accounts will be DELETED:"
for user in "${users_to_delete[@]}"; do
    echo "- $user"
done
echo ""

read -p "Are you absolutely sure you want to delete these users and their home directories? This action is irreversible. (yes/no): " confirmation

if [[ "$confirmation" == "yes" ]]; then
    for user in "${users_to_delete[@]}"; do
        echo "Deleting user: $user..."
        # Remove the user in MacOS
        sudo dscl . delete /Users/"$user"
        # rmrf the home folder
        sudo rm -rf /Users/"$user"
        if [ $? -eq 0 ]; then
            echo "Successfully deleted user '$user' and their home directory."
        else
            echo "Error deleting user '$user'. Please check for specific error messages above."
        fi
    done
    echo ""
    echo "Deletion process complete."
else
    echo "Deletion cancelled."
fi


echo "Completed, press enter to exit!"
read