#!/bin/bash

set -ueo pipefail

ORGANIZATION=$ORGANIZATION
ACCESS_TOKEN=$ACCESS_TOKEN
SSK_PRIVATE_KEY=$SSK_PRIVATE_KEY
GITHUB_EMAIL=$GITHUB_EMAIL
GITHUB_USER=$GITHUB_USER
_RUNNER_NAME=${RUNNER_NAME:-${RUNNER_NAME_PREFIX:-github-runner}-$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 13 ; echo '')}

# restore home directory
cp -r /runner/home/* ~/
# setup yarn cache
mkdir -p ~/.cache/yarn
yarn config set cache-folder ~/.cache/yarn

mkdir -p ~/.ssh

# add ssh private key this
echo "${SSK_PRIVATE_KEY}" > ~/.ssh/id_ssh
chmod 600 ~/.ssh/id_ssh
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ssh

# add github.com to known hosts
touch ~/.ssh/known_hosts
ssh-keyscan github.com >> ~/.ssh/known_hosts

# setup git config
git config --global user.email "${GITHUB_EMAIL}"
git config --global user.name "${GITHUB_USER}"

# test the setup
git ls-remote --tags --heads ssh://git@github.com/Project-Pandora-Game/pandora.git
if [ $? -eq 0 ]; then
	echo "GitHub repository exists"
else
	echo "GitHub repository does not exist"
	exit 1
fi

REG_TOKEN=$(curl -sX POST -H "Authorization: token ${ACCESS_TOKEN}" https://api.github.com/orgs/${ORGANIZATION}/actions/runners/registration-token | jq .token --raw-output)
cd /home/docker/actions-runner

echo "Configuring"
./config.sh \
	--url https://github.com/${ORGANIZATION} \
	--token "${REG_TOKEN}" \
	--name "${_RUNNER_NAME}" \
	--unattended \
	--disableupdate \
	--replace || true

cleanup() {
	echo "Removing runner..."
	rm -rf ~/.ssh/id_ssh
	./config.sh remove --token "${REG_TOKEN}"
	exit
}

trap cleanup SIGINT SIGQUIT SIGTERM INT TERM QUIT EXIT

./run.sh & wait $!
