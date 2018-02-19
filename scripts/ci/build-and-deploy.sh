#!/usr/bin/env bash

set -e

DIR=$(git rev-parse --show-toplevel)

docker pull "qgis/qgis:${QGIS_VERSION}"

docker build --build-arg QGIS_VERSION=${QGIS_VERSION} -t qgis/qgis-python-api-doc .

docker run qgis/qgis-python-api-doc
