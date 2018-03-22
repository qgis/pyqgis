#!/usr/bin/env bash

set -e

DOCKER_TAG=$1

DIR=$(git rev-parse --show-toplevel)

THEME_PATH=$(../install_rtd_version_theme.sh | egrep '^Installed.*\.egg$' | sed 's/^Installed //')
echo "Custom theme installed in ${THEME_PATH}"

../build-docs.sh -v ${DOCKER_TAG} -t ${THEME_PATH}
