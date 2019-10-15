#!/usr/bin/env bash

# for a quick local run (few classes):
# QGIS_VERSION_BRANCH=master BUILD_OPTIONS='-c QgsVectorLayer -c QgsFeature' PUBLISH=false ./scripts/run-docker.sh
# or for all core (but no gui, analysis, etc):
# QGIS_VERSION_BRANCH=master BUILD_OPTIONS='-p core' PUBLISH=false ./scripts/run-docker.sh

set -e

# GNU prefix command for mac os support (gsed, gsplit)
GP=
if [[ "$OSTYPE" =~ darwin* ]]; then
  GP=g
fi

DIR=$(git rev-parse --show-toplevel)

pushd ${DIR}

QGIS_DOCKER_TAG="$(sed 's/master/latest/' <<<${QGIS_VERSION_BRANCH})"
if [[ ${QGIS_DOCKER_TAG} =~ (final|release)-3_(4|6) ]]; then
  QGIS_DOCKER_TAG="${QGIS_DOCKER_TAG}_cosmic"
else
  QGIS_DOCKER_TAG="${QGIS_DOCKER_TAG}_disco"
fi

# latest => master, final-3_0_2 => 3.0
QGIS_VERSION=$(${GP}sed -r 's/latest(_cosmic|_disco)?/master/; s/^(final|release)-([0-9]_[0-9])(_[0-9])?(_cosmic|_disco)?/\2/; s/_/./g' <<<$QGIS_DOCKER_TAG)
echo "QGIS Docker tag: ${QGIS_DOCKER_TAG}"
echo "Building for QGIS: ${QGIS_VERSION}"

echo "travis_fold:start:pullqgis" && echo "Pull QGIS"
docker pull "qgis/qgis:${QGIS_DOCKER_TAG}"
echo "travis_fold:end:pullqgis"

echo "travis_fold:start:dockerbuild" && echo "Docker build"
docker build --build-arg QGIS_DOCKER_TAG=${QGIS_DOCKER_TAG} -t qgis/qgis-python-api-doc:${QGIS_DOCKER_TAG} .
echo "travis_fold:end:dockerbuild"

echo "travis_fold:start:dockerrun" && echo "Docker run"
docker rm -f pyqgis || true
docker run --name pyqgis \
  -e "QGIS_VERSION=${QGIS_VERSION}" \
  -e "BUILD_TESTING=${BUILD_TESTING}" \
  -e "BUILD_OPTIONS=${BUILD_OPTIONS}" \
  qgis/qgis-python-api-doc:${QGIS_DOCKER_TAG}
echo "travis_fold:end:dockerrun"

echo "Copy files"
mkdir -p ${DIR}/build
mkdir -p ${DIR}/build/${QGIS_VERSION}
CONTAINER_ID=$(docker ps -aqf "name=pyqgis")
docker cp ${CONTAINER_ID}:/root/pyqgis/build/${QGIS_VERSION}/html ${DIR}/build/${QGIS_VERSION}

if [[ ${PUBLISH} -ne "false" ]]; then
  ./scripts/publish-docs.sh ${QGIS_VERSION} ${DIR}/build/${QGIS_VERSION}/html
fi

popd
