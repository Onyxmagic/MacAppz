#!/bin/bash
# /usr/local/bin/prepareForShutdown.sh

#  ██████   █████   █████████  █████ ███████████
# ░░██████ ░░███   ███░░░░░███░░███ ░█░░░███░░░█
#  ░███░███ ░███  ███     ░░░  ░███ ░   ░███  ░ 
#  ░███░░███░███ ░███          ░███     ░███    
#  ░███ ░░██████ ░███          ░███     ░███    
#  ░███  ░░█████ ░░███     ███ ░███     ░███    
#  █████  ░░█████ ░░█████████  █████    █████   
#  ░░░░░    ░░░░░   ░░░░░░░░░  ░░░░░    ░░░░░    

# <------------------------------------------------------>
# | MacOS quickscript for setting power (if no flag set) |
# | Setting the Timezone to TARGET_TIMEZONE              |
# | Then force logging out users                         |
# | Set pmset to about 15 minutes after this runs        |
# | Bendahon 2025                                        |
# | 
# | V1.1                                                 |
# <------------------------------------------------------>

# What Timezone are you in
TARGET_TIMEZONE="Australia/Brisbane"

# Ensure log file exists and is writable, Fallback to /dev/null if cannot create
LOGFILE="/var/log/prepare_for_shutdown.log"
touch "$LOGFILE" 2>/dev/null || LOGFILE="/dev/null"
echo "$(date): Starting prepareForShutdown script." >> "$LOGFILE"

# --------PMSET-------- #
# Define the flag file path for pmset setup
PMSET_SETUP_FLAG="/var/root/pmset_setup_done"
if [ ! -f "$PMSET_SETUP_FLAG" ]; then
    echo "$(date): $PMSET_SETUP_FLAG not found. Performing initial pmset network time setup." >> "$LOGFILE"

    echo "$(date): Enabling network time and setting server." >> "$LOGFILE"
    # /usr/sbin/systemsetup -setusingnetworktime on
    if [ $? -ne 0 ]; then
        echo "$(date): ERROR: Failed to enable network time." >> "$LOGFILE"
    fi
    # /usr/sbin/systemsetup -setnetworktimeserver time.apple.com
    if [ $? -ne 0 ]; then
        echo "$(date): ERROR: Failed to set network time server." >> "$LOGFILE"
    fi

    # Create the flag file to indicate pmset network time setup is complete
    pmset repeat shutdown MTWRFSU 19:00:00
    if [ $? -ne 0 ]; then
        echo "$(date): ERROR: Failed to create pmset setup flag file: $PMSET_SETUP_FLAG." >> "$LOGFILE"
        exit 1
    fi
    /usr/bin/touch "$PMSET_SETUP_FLAG"
    echo "$(date): Initial pmset network time setup complete. Flag file touched." >> "$LOGFILE"
else
    echo "$(date): $PMSET_SETUP_FLAG found. Skipping pmset network time setup." >> "$LOGFILE"
fi

# --------SetTimeZone-------- #
echo "$(date): Setting timezone to $TARGET_TIMEZONE." >> "$LOGFILE"
/usr/sbin/systemsetup -settimezone "$TARGET_TIMEZONE"
if [ $? -ne 0 ]; then
    echo "$(date): ERROR: Failed to set timezone to $TARGET_TIMEZONE." >> "$LOGFILE"
fi

echo "$(date): Enabling network time and setting server." >> "$LOGFILE"
/usr/sbin/systemsetup -setusingnetworktime on
if [ $? -ne 0 ]; then
    echo "$(date): ERROR: Failed to enable network time." >> "$LOGFILE"
fi
/usr/sbin/systemsetup -setnetworktimeserver time.apple.com
if [ $? -ne 0 ]; then
    echo "$(date): ERROR: Failed to set network time server." >> "$LOGFILE"
fi

# --------ForceLogoutUsers-------- #
echo "$(date): Starting force logout process." >> "$LOGFILE"

ACTIVE_USER_UIDS=$(/bin/ps -axo uid,comm | /usr/bin/grep loginwindow | /usr/bin/grep -v grep | /usr/bin/awk '{print $1}' | /usr/bin/sort -u)

if [ -z "$ACTIVE_USER_UIDS" ]; then
    echo "$(date): No active graphical users found to log out." >> "$LOGFILE"
else
    echo "$(date): Found active graphical users with UIDs: $ACTIVE_USER_UIDS" >> "$LOGFILE"
    for uid in $ACTIVE_USER_UIDS; do
        if [ "$uid" -ne 0 ]; then
            echo "$(date): Attempting to log out user with UID: $uid" >> "$LOGFILE"
            /bin/launchctl bootout gui/"$uid"
            if [ $? -eq 0 ]; then
                echo "$(date): Successfully sent logout command for UID: $uid" >> "$LOGFILE"
            else
                echo "$(date): Failed to send logout command for UID: $uid" >> "$LOGFILE"
            fi
        else
            echo "$(date): Skipping root user (UID 0)." >> "$LOGFILE"
        fi
    done
fi

echo "$(date): Force logout process finished." >> "$LOGFILE"
echo "$(date): prepareForShutdown script finished." >> "$LOGFILE"

exit 0