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
# | Ableton online cleaner installer    |
# | Bendahon 2025                       |
# | I hear those voices over the noises |
# | V1.1                                |
# <------------------------------------->

# -------- Step1 -------- #
# Disable Wifi
echo "Press enter to start"
read
sudo networksetup -setairportpower en1 off
# With internet disabled open Ableton
open -n /Applications/Ableton\ Live\ 11\ Suite.app
echo "Open Ableton and disable auto updates"
echo "Authorise Later"
echo "Help > User Accounts and Licenses > Get Automatic Updates > Never"
echo "Press Enter when you've done this"
read

# -------- Step2 -------- #
# Kill ableton again
sudo pkill -9 Live
echo "Re-enable WiFi"
sleep 3
sudo networksetup -setairportpower en1 on
echo "WiFi should reconnect...."
sleep 5
echo "Opening Ableton, now authorise online"
open -n /Applications/Ableton\ Live\ 11\ Suite.app
echo "Press Enter once you've authorised Ableton"
read

# -------- Step3 -------- #
# Kill Live Again, this step might not actually be needed
sudo pkill -9 Live
sleep 2

# Make Global Folder
echo "Making Library Folders"
sudo mkdir -p /Library/Application\ Support/Ableton/Live\ 11.3.30/Unlock
echo "Moving Unlock File"

# Move the license over
sudo mv /Users/ncadmin/Library/Application\ Support/Ableton/Live\ 11.3.30/Unlock/*.* /Library/Application\ Support/Ableton/Live\ 11.3.30/Unlock/
echo "Deleting Existing Folders"

# Don't run this as root or with -f
rm -r /Users/ncadmin/Library/Application\ Support/Ableton/Live\ 11.3.30

# Make the global Ableton Folder
sudo mkdir -p /Library/Preferences/Ableton/Live\ 11.3.30/

# Write the "Auto Update Disabler" as root
sudo su - <<EOF
echo "-_DisableAutoUpdates" > /Library/Preferences/Ableton/Live\ 11.3.30/Options.txt
EOF
# Finally remove the preferences file, for some reason
rm -r /Users/ncadmin/Library/Preferences/Ableton/Live\ 11.3.30

echo "Completed, press enter to exit!"
read
