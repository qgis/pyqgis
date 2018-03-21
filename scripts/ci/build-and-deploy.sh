#!/usr/bin/env bash

set -e

DIR=$(git rev-parse --show-toplevel)

pushd ${DIR}

docker pull "qgis/qgis:${QGIS_VERSION_BRANCH}"

QGIS_DOCKER_TAG=$(sed 's/master/latest/' <<< ${QGIS_VERSION_BRANCH})

docker build --build-arg QGIS_DOCKER_TAG=${QGIS_DOCKER_TAG} -t qgis/qgis-python-api-doc .

docker run qgis/qgis-python-api-doc

popd
