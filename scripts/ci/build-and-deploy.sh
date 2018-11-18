#!/usr/bin/env bash

set -e

# latest => master, final-3_0_2 => 3.0
QGIS_DOCKER_TAG=$1
QGIS_VERSION=$( sed -r 's/latest(_cosmic)?/master/; s/^(final|release)-([0-9]_[0-9])(_[0-9])?(_cosmic)?/\2/; s/_/./g' <<< $QGIS_DOCKER_TAG )
echo "Building for ${QGIS_VERSION}"

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

THEME_PATH=$(${DIR}/../install_rtd_version_theme.sh | egrep '^Installed.*\.egg$' | sed 's/^Installed //')
echo "Custom theme installed in ${THEME_PATH}"

${DIR}/../build-docs.sh -v ${QGIS_VERSION} -t ${THEME_PATH}

export TRAVIS=true
${DIR}/../publish-docs.sh ${QGIS_VERSION}
