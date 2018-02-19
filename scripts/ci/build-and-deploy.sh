#!/usr/bin/env bash

set -e

DIR=$(git rev-parse --show-toplevel)

docker pull "qgis/qgis:${QGIS_VERSION}"


docker run -it qgis/qgis:${QGIS_VERSION} ${DIR}/scripts/build-docs.sh
