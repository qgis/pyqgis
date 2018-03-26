#!/usr/bin/env bash

set -e

DIR=$(git rev-parse --show-toplevel)

pushd ${DIR}

QGIS_DOCKER_TAG=$(sed 's/master/latest/' <<< ${QGIS_VERSION_BRANCH})

echo "travis_fold:start:pullqgis"
echo "Pull QGIS"
docker pull "qgis/qgis:${QGIS_DOCKER_TAG}"
echo "travis_fold:end:pullqgis"

echo "travis_fold:start:dockerbuild"
echo "Docker build"
docker build --build-arg QGIS_DOCKER_TAG=${QGIS_DOCKER_TAG} -t qgis/qgis-python-api-doc:${QGIS_DOCKER_TAG} .
echo "travis_fold:end:dockerbuild"

echo "travis_fold:start:dockerrun"
echo "Docker run"
docker run -e "QGIS_DOCKER_TAG=${QGIS_DOCKER_TAG}" -e "GH_TOKEN=${GH_TOKEN}" qgis/qgis-python-api-doc
echo "travis_fold:end:dockerrun"

popd
