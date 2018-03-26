#!/usr/bin/env bash

set -e

# latest => master, final-3_0_2 => 3.0
QGIS_DOCKER_TAG=$1
QGIS_VERSION=$( sed -r 's/latest/master/; s/^final-(\d_\d)(_\d)?/\1/; s/_/./g' <<< $DOCKER_IMAGE )
echo "Building for ${QGIS_VERSION}"

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

THEME_PATH=$(${DIR}/../install_rtd_version_theme.sh | egrep '^Installed.*\.egg$' | sed 's/^Installed //')
echo "Custom theme installed in ${THEME_PATH}"

${DIR}/../build-docs.sh -v ${QGIS_VERSION} -t ${THEME_PATH} -p gui -c QgsMapCanvas

export TRAVIS=true
${DIR}/../publish-docs.sh ${QGIS_VERSION}
