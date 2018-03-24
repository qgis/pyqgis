#!/usr/bin/env bash

set -e

# latest => master, release-3_0 => 3.0
QGIS_VERSION=$( sed 's/latest/master/; s/release-//; s/_/./g' <<< "$1" )

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

THEME_PATH=$(${DIR}/../install_rtd_version_theme.sh | egrep '^Installed.*\.egg$' | sed 's/^Installed //')
echo "Custom theme installed in ${THEME_PATH}"

${DIR}/../build-docs.sh -v ${QGIS_VERSION} -t ${THEME_PATH}

${DIR}/../publish-docs.sh ${QGIS_VERSION}
