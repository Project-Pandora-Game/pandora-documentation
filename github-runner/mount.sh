#!/bin/bash

set -ueo pipefail

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
TMPFS_SIZE=${TMPFS_SIZE:-"4G"}

mount -t tmpfs -o size=4G tmpfs ${SCRIPT_DIR}/cache
chmod -R a+rwX ${SCRIPT_DIR}/cache
