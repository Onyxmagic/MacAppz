#!/bin/bash

#  ██████   █████   █████████  █████ ███████████
# ░░██████ ░░███   ███░░░░░███░░███ ░█░░░███░░░█
#  ░███░███ ░███  ███     ░░░  ░███ ░   ░███  ░ 
#  ░███░░███░███ ░███          ░███     ░███    
#  ░███ ░░██████ ░███          ░███     ░███    
#  ░███  ░░█████ ░░███     ███ ░███     ░███    
#  █████  ░░█████ ░░█████████  █████    █████   
#  ░░░░░    ░░░░░   ░░░░░░░░░  ░░░░░    ░░░░░    

# <------------------------------------------>
# |  MacOS System updater from command line |
# | Bendahon 2025                           |
# | 
# | V1.0                                    |
# <----------------------------------------->

echo "---------------------------------------------------------"
echo "         macOS System Update and Reboot Script           "
echo "---------------------------------------------------------"
echo ""
echo "This script will check for and install all available macOS updates."
echo "Your system will reboot automatically after the updates are installed."
echo ""
echo "Please ensure you have saved all your work before proceeding."
echo "You will be prompted for your administrator password a few times."
echo ""

# Prompt the user to press Enter to continue
read -p "Press Enter to start the update process, or Ctrl+C to cancel."

echo ""
echo "Initiating macOS software update..."
echo "(You may be prompted for your administrator password.)"
echo ""

# Execute the update command
# --install: Installs the available updates.
# --all: Installs all available updates.
# --reboot: Reboots the system after successful installation.
sudo softwareupdate --install --all --reboot

echo ""
echo "---------------------------------------------------------"
echo " Update process initiated. Your system should now be "
echo " checking for updates and will reboot if necessary.     "
echo "---------------------------------------------------------"