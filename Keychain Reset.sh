#!/bin/bash





# Get the current User
User=`python -c 'from SystemConfiguration import SCDynamicStoreCopyConsoleUser; import sys; username = (SCDynamicStoreCopyConsoleUser(None, None, None) or [None])[0]; username = [username,""][username in [u"loginwindow", None, u""]]; sys.stdout.write(username + "\n");'`

# Get the current user's home directory
UserHomeDirectory=$(/usr/bin/dscl . -read Users/"${User}" NFSHomeDirectory | awk '{print $2}')



	# Get the current User's default (login) keychain
	CurrentKeychain=$(su "${User}" -c "security list-keychains" | grep login | sed -e 's/\"//g' | sed -e 's/\// /g' | awk '{print $NF}')

	if [[ -z $CurrentKeychain ]]; then
		echo "Keychain Repair: Unable to find a login keychain for User $User"
	else
		echo "Keychain Repair: Found $UserHomeDirectory/Library/Keychains/${CurrentKeychain} - deleting"
		mv $UserHomeDirectory/Library/Keychains/$CurrentKeychain $UserHomeDirectory/Library/Keychains/$User.keychain.bkp
	fi



 


	#Set the newly created login.keychain as the Users default keychain
	su "${User}" -c "security default-keychain -s login.keychain"

	#Unset timeout/lock behavior
	su "${User}" -c "security set-keychain-settings login.keychain"

	# Current user's Local Items keychain
	LocalItemsKeychainHash=$(ls "${UserHomeDirectory}"/Library/Keychains/ | egrep '([A-Z0-9]{8})((-)([A-Z0-9]{4})){3}(-)([A-Z0-9]{12})')

	if [[ -z $LocalItemsKeychainHash ]]; then
		echo "Keychain Repair: Unable to find a Local Items keychain"
	else
 		echo "Keychain Repair: Deleting ${UserHomeDirectory}/Library/Keychains/${LocalItemsKeychainHash}"
		rm -rf ${UserHomeDirectory}/Library/Keychains/${LocalItemsKeychainHash}
	fi


	exit 0
else
	echo "Keychain Repair: User '${User}' decided to cancel"
	exit 0
fi