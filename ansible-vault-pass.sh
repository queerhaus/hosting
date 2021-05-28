#!/bin/bash
#set -x

# This script will unlock your bitwarden vault and store the session id for quick reuse later
# Inspired by: https://berk.es/2019/10/19/ansible-vault-password-with-bitwarden/

# This is the name of the password in the Bitwarden vault
bw_vault_entry_id="queerhaus-ansible-vault"

if ! which bw > /dev/null; then
	>&2 echo "You need to install the bitwarden cli tool: https://bitwarden.com/help/article/cli/#quick-start"
	exit 1
fi

# Check if we already have a session stored in keychain
if which keyring > /dev/null; then
	if keyring get queerhaus bitwarden-session &>/dev/null; then
		export BW_SESSION="$(keyring get queerhaus bitwarden-session)"
	fi
elif which keyctl > /dev/null; then
	if keyctl search @us user bw_session &>/dev/null; then
		export BW_SESSION="$(keyctl print $(keyctl search @us user bw_session 2>/dev/null))"
	fi
elif which security > /dev/null; then
	if security find-generic-password -s queerhaus-vault -a bitwarden-session -w &>/dev/null; then
		export BW_SESSION="$(security find-generic-password -s queerhaus-vault -a bitwarden-session -w)"
	fi
else
	>&2 echo "This script requires either the 'keyctl' or 'keyring' command on Linux or 'security' command on macOS"
	exit 1
fi

# Try to get the bitwarden status
status_output="$(bw status 2>/dev/null)"
if [[ $status_output =~ ^\{.*$ ]]; then
	# Valid json, parse it
	status="$(echo $status_output | jq -r .status)"
else
	>&2 echo "Stored session invalid, need to recreate"
	unset BW_SESSION
	status="$(bw status 2>/dev/null | jq -r .status)"
fi

# Verify the session status
if [ "$status" = "unauthenticated" ]; then
	>&2 echo "You need to log in to your bitwarden account"
	export BW_SESSION="$(bw login --raw)"
elif [ "$status" = "locked" ]; then
	>&2 echo "You need to unlock your bitwarden vault"
	export BW_SESSION="$(bw unlock --raw)"
fi

# Check that session did not fail
if [ -z "$BW_SESSION" ]; then
	>&2 echo "Failed to get bitwarden session"
	exit 1
fi

# Store this session
if which keyring > /dev/null; then
	python3 -c "import keyring; keyring.set_password('queerhaus', 'bitwarden-session', '$BW_SESSION')"
elif which keyctl > /dev/null; then
	if keyctl search @us user bw_session &>/dev/null; then
		echo -n $BW_SESSION | keyctl pupdate $(keyctl search @us user bw_session 2>/dev/null)
	else
		echo -n $BW_SESSION | keyctl padd user bw_session @us
	fi
elif which security > /dev/null; then
	security add-generic-password -s queerhaus-vault -a bitwarden-session -U -w $BW_SESSION
fi

vault_password="$(bw get password ${bw_vault_entry_id} --raw)"

if [ $? -ne 0 ]; then
	# Maybe bitwarden needs to sync, one last attempt
	bw sync
	vault_password="$(bw get password ${bw_vault_entry_id} --raw)"
	if [ $? -ne 0 ]; then
		>&2 echo "Failed to get ansible vault password from bitwarden"
		exit 1
	fi
fi

# Retrieve the vault password and print it
echo -n $vault_password