#!/bin/bash
# /Volumes/MacAppz/SysInit.sh

#  ██████   █████   █████████  █████ ███████████
# ░░██████ ░░███   ███░░░░░███░░███ ░█░░░███░░░█
#  ░███░███ ░███  ███     ░░░  ░███ ░   ░███  ░ 
#  ░███░░███░███ ░███          ░███     ░███    
#  ░███ ░░██████ ░███          ░███     ░███    
#  ░███  ░░█████ ░░███     ███ ░███     ░███    
#  █████  ░░█████ ░░█████████  █████    █████   
#  ░░░░░    ░░░░░   ░░░░░░░░░  ░░░░░    ░░░░░    

# <----------------------------->
# | MacOS Prepper and installer |
# | Bendahon 2025               |
# | I'm better off this way     |
# | V1.2                        |
# <----------------------------->
# Changelog
# 1.2 - Added Changelog
#     - Added Jamf Policy + Recon

# -------- StopExisting -------- #
# For the equivilent of systemctl stop prepareforshutdown --now
# Now I can reinstall the service at any time
sudo launchctl disable system/com.nudgee.prepareforshutdown
sudo launchctl unload /Library/LaunchDaemons/com.nudgee.prepareforshutdown.plist

# -------- StartExisting -------- #
# Send a heartbeat to JAMF
sudo jamf recon
# Grab any Policies
sudo jamf policy

# -------- GetMeThere -------- #
# If the drive is always called MacAppz then this will always be true
cd /Volumes/MacAppz/SysInit/

# -------- SystemUpdateScript -------- #
# Copy in the System Updater
sudo cp systemUpdate.sh /usr/local/bin/systemUpdate
# Change permissions 
sudo chown ncadmin:admin /usr/local/bin/systemUpdate
sudo chmod 500 /usr/local/bin/systemUpdate

# -------- Prep4Shutdown -------- #
# Copy in the prepare For Shutdown script
sudo cp prepareForShutdown.sh /usr/local/bin/prepareForShutdown.sh
sudo chmod +x /usr/local/bin/prepareForShutdown.sh

# -------- LaunchDSetup -------- #
# Copy in the Launch Daemon PLIST
sudo cp systemSetupPList.xml /Library/LaunchDaemons/com.nudgee.prepareforshutdown.plist
sudo chown root:wheel /Library/LaunchDaemons/com.nudgee.prepareforshutdown.plist
sudo chmod 644 /Library/LaunchDaemons/com.nudgee.prepareforshutdown.plist
# For the equivilent of systemctl start prepareforshutdown --now
# This will probably error but we just ignore it
sudo launchctl load /Library/LaunchDaemons/com.nudgee.prepareforshutdown.plist
sudo launchctl enable system/com.nudgee.prepareforshutdown
sudo launchctl enable system/com.nudgee.prepareforshutdown
sudo launchctl load /Library/LaunchDaemons/com.nudgee.prepareforshutdown.plist

# -------- iMacSpecific -------- #
# Copy the wallpaper in
sudo cp /Volumes/MacAppz/wallpaper.jpg /Users/Shared/wallpaper.jpg
# So I can run this multiple times
echo "Press enter to install Music Apps"
read
echo "Installing MuseScore"
sudo cp -R /Volumes/MacAppz/MuseScore\ 4.app /Applications/
echo "Installing Sublime"
sudo cp -R /Volumes/MacAppz/Sublime\ Text.app /Applications/
echo "Installing Ableton"
sudo cp -R /Volumes/MacAppz/Ableton\ Live\ 11\ Suite.app /Applications/
echo "Mounting Sibelius"
sudo hdiutil attach /Volumes/MacAppz/Sibelius_2021.2_Mac.dmg
# Copy to Downloads
cp /Volumes/MacAppz/Sibelius_Sounds_Mac.dmg /Users/ncadmin/Downloads/sib.dmg
cp /Volumes/MacAppz/Install\ FL\ Studio.pkg /Users/ncadmin/Downloads/FL.pkg

# -------- Fin -------- #
echo "Completed - you will have to manually mount Sib.dmg in Downloads"
echo "And install FL.pkg manually (with internet)"
echo "Press enter to exit"
read
