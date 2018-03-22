#!/usr/bin/env bash

set -e

DIR=$(git rev-parse --show-toplevel)

pushd ${DIR}

QGIS_DOCKER_TAG=$(sed 's/master/latest/' <<< ${QGIS_VERSION_BRANCH})
echo "QGIS_DOCKER_TAG: ${QGIS_DOCKER_TAG}"

echo "Pull QGIS"
docker pull "qgis/qgis:${QGIS_DOCKER_TAG}"

echo "Docker build"
docker build --build-arg QGIS_DOCKER_TAG=${QGIS_DOCKER_TAG} -t qgis/qgis-python-api-doc:${QGIS_DOCKER_TAG} .

echo "Docker run"
docker run -e "QGIS_DOCKER_TAG=${QGIS_DOCKER_TAG}" qgis/qgis-python-api-doc

popd
