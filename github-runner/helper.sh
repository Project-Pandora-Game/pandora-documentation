#!/bin/bash

# https://testdriven.io/blog/github-actions-docker/

IMAGE_NAME="pandora-runner"

ORGANIZATION="Project-Pandora-Game"

if [ -z "${ACCESS_TOKEN}" ]; then
	echo "ACCESS_TOKEN is not set"
	exit 1
fi

if [ -z "${GITHUB_EMAIL}" ]; then
	GITHUB_EMAIL=$(git config --get user.email)
fi

if [ -z "${GITHUB_USER}" ]; then
	GITHUB_USER=$(git config --get user.name)
fi

if [ -z "${SSK_PRIVATE_KEY}" ]; then
	if [ ! -f "./id_ssh" ]; then
		echo "SSK_PRIVATE_KEY is not set and id_ssh file does not exist"
		exit 1
	fi
	SSK_PRIVATE_KEY=$(cat ./id_ssh)
fi

function build_image() {
	docker images rm -f ${IMAGE_NAME}
	docker build -t ${IMAGE_NAME} .
}

function run_image() {
	local runner_name="$1"
	if [ -z "${runner_name}" ]; then
		runner_name="pandora-runner-$(date +%s)"
	fi

	docker run \
		--detach \
		--restart=always \
		--env ACCESS_TOKEN="$ACCESS_TOKEN" \
		--env GITHUB_EMAIL="$GITHUB_EMAIL" \
		--env GITHUB_USER="$GITHUB_USER" \
		--env RUNNER_NAME_PREFIX="${RUNNER_NAME_PREFIX:-github-runner}" \
		--env ORGANIZATION="$ORGANIZATION" \
		--env SSK_PRIVATE_KEY="$SSK_PRIVATE_KEY" \
		--name ${runner_name} \
		${IMAGE_NAME}
}


function usage() {
	echo "Usage: $0 [build|run|log]"
	echo "  build: build docker image"
	echo "  run: run docker image"
	echo "    [runner_name]: run docker image with runner_name"
	echo "  log: log docker image"
}

function log_image() {
	local runner_name="$1"
	if [ -z "${runner_name}" ]; then
		usage
		exit 1
	fi

	docker logs -f ${runner_name}
}

KEY=$1
shift

case $KEY in
	"build")
		build_image
		;;
	"run")
		run_image "$@"
		;;
	"log")
		log_image "$@"
		;;
	*)
		usage
		exit 1
		;;
esac
