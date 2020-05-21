#!/usr/bin/env bash

# SOURCE:
# https://www.jamf.com/jamf-nation/discussions/22545/how-to-have-jamf-re-add-mdm-profile#responseChild136268

# activate verbose standard output (stdout)
set -v
# activate debugging (execution shown)
set -x

# Current user
# logged_in_user=$(logname) # posix alternative to /dev/console

# Working directory
# script_dir=$(cd "$(dirname "$0")" && pwd)

# Set $IFS to eliminate whitespace in pathnames
IFS="$(printf '\n\t')"

# Remove Jamf MDM
jamf removeMDMProfile

# Remove Configuration Profiles
rm -rf /var/db/ConfigurationProfiles
sleep 20

# Enable Jamf MDM
jamf mdm
sleep 20

# Enforces the entire management framework from the JSS
jamf manage

# deactivate verbose and debugging stdout
set +v
set +x

unset IFS

exit 0