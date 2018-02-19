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

if [[ -z $QGIS_BUILD_DIR ]]; then
  while :; do
      case $1 in
          -q|--qgis-build-dir) QGIS_BUILD_DIR=$2
          shift
          ;;
          *) break
      esac
      case $1 in
          -p|--package) $PACKAGE="--package=$2"
          shift
          ;;
          *) break
      esac
      case $1 in
          -c|--class) $CLASS="--class=$2"
          shift
          ;;
          *) break
      esac
      shift
  done
fi

if [[ -n $QGIS_BUILD_DIR ]]; then
  export PYTHONPATH=$PYTHONPATH:$QGIS_BUILD_DIR/output/python
  #export PATH=$PATH:/usr/local/bin/:$QGIS_BUILD_DIR/build/output/bin
fi
export PYTHONPATH=$PYTHONPATH:${DIR}/..


echo "travis_fold:start:make_api_rst"
echo "make API RST"
./rst/make_api_rst.py $PACKAGE $CLASS
echo "travis_fold:end:make_api_rst"

make html

popd
