#!/usr/bin/env bash

set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

pushd ${DIR}/..

QGIS_VERSION=master
while getopts "q:p:c:v:" opt; do
  case $opt in
    v)
      QGIS_VERSION=$OPTARG
      ;;
    q)
      QGIS_BUILD_DIR=$OPTARG
      ;;
    p)
      if [[ -z $PACKAGE ]]; then
        PACKAGE="--package $OPTARG"
      else
        PACKAGE="$PACKAGE $OPTARG"
      fi
      ;;
    c)
      if [[ -z $CLASS ]]; then
        CLASS="--class $OPTARG"
      else
        CLASS="$CLASS $OPTARG"
      fi
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
  esac
done
shift $(expr $OPTIND - 1)

echo "QGIS VERSION: ${QGIS_VERSION}"
echo "PACKAGE LIMIT: ${PACKAGE}"

if [[ -n $QGIS_BUILD_DIR ]]; then
  export PYTHONPATH=$PYTHONPATH:$QGIS_BUILD_DIR/output/python
  #export PATH=$PATH:/usr/local/bin/:$QGIS_BUILD_DIR/build/output/bin
fi
export PYTHONPATH=$PYTHONPATH:${DIR}/..
echo "setting PYTHONPATH $PYTHONPATH"


echo "travis_fold:start:make_api_rst"
echo "make API RST ./scripts/make_api_rst.py $PACKAGE $CLASS -v $QGIS_VERSION"
./scripts/make_api_rst.py $PACKAGE $CLASS -v ${QGIS_VERSION}
cp -r _templates api/${QGIS_VERSION}/_templates
echo "travis_fold:end:make_api_rst"

echo "travis_fold:start:build_html"
echo "build HTML"
make prepare QGISVERSION=${QGIS_VERSION}
make html QGISVERSION=${QGIS_VERSION}
echo "travis_fold:end:build_html"


popd
