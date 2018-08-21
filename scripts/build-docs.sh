#!/usr/bin/env bash

set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

pushd ${DIR}/..

# https://stackoverflow.com/questions/16989598/bash-comparing-version-numbers
function version_gt() { test "$(printf '%s\n' "$@" | sort -V | head -n 1)" != "$1"; }
if version_gt '4.19.7' $(sip -V); then
     echo "Your version of SIP is too old. SIP 4.19.7+ is required"
     exit 1
fi

QGIS_VERSION=master

while getopts "q:p:c:v:t:" opt; do
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
      CLASS="--class $OPTARG"
      ;;
    t)
      THEME_PATH=$OPTARG
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
  esac
done
shift $(expr $OPTIND - 1)

echo "QGIS VERSION: ${QGIS_VERSION}"
echo "THEME PATH: ${THEME_PATH}"

if [[ -n $QGIS_BUILD_DIR ]]; then
  export PYTHONPATH=$PYTHONPATH:$QGIS_BUILD_DIR/output/python
  #export PATH=$PATH:/usr/local/bin/:$QGIS_BUILD_DIR/build/output/bin
fi
export PYTHONPATH=$PYTHONPATH:${DIR}/..
echo "setting PYTHONPATH $PYTHONPATH"


echo "travis_fold:start:make_api_rst"
echo "make API RST ./rst/make_api_rst.py $PACKAGE $CLASS -v ${QGIS_VERSION}"
./rst/make_api_rst.py $PACKAGE $CLASS -v ${QGIS_VERSION}
echo "travis_fold:end:make_api_rst"

echo "travis_fold:start:build_html"
echo "build HTML"
make prepare QGISVERSION=${QGIS_VERSION} SPHINX_RTD_EGG_PATH=${THEME_PATH}
make html QGISVERSION=${QGIS_VERSION}
#make rinoh QGISVERSION=${QGIS_VERSION}
echo "travis_fold:end:build_html"

popd
