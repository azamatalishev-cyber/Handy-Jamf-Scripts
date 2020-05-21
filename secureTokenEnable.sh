#!/bin/sh

#  Enable User For FileVault.sh
#  
#
#  Created by Dennis Nardi on 2/20/18.
#  

curUser=$(/usr/bin/stat -f%Su /dev/console)
curPass=$password for admin account with secure token

## Get the desired user's account
echo "Prompting ${curUser} for the desired user to enable for FV2."
Newuser="$(/usr/bin/osascript -e 'Tell current application to display dialog "Please enter the desired user to enable for FV2:" default answer "" with title "Window Title" with text buttons {"Ok"} default button 1 ' -e 'text returned of result')"


## Get the desired user's password
echo "Prompting ${curUser} for the password for desired user to enable for FV2."
NewuserPass="$(/usr/bin/osascript -e 'Tell current application to display dialog "Please enter the password for the desired user:" default answer "" with title "Window Title" with text buttons {"Ok"} default button 1 with hidden answer' -e 'text returned of result')"


## Sets new user with a secure token so it can be enabled for FV2. This requires GUI authentication from the local account but can be run from any account as if secure token admin credentials are entered
sudo sysadminctl interactive -secureTokenOn $Newuser -password $NewuserPass

## This "expect" block will populate answers for the fdesetup prompts that normally occur while hiding them from output
expect -c "
log_user 0
spawn fdesetup add -usertoadd $Newuser
expect \"Enter the user name:\"
send "${curUser}"\r
expect \"Enter the password for user '${curUser}':\"
send "${curPass}"\r
expect \"Enter the password for the added user '$Newuser':\"
send "${NewuserPass}"\r
log_user 1
expect eof
"