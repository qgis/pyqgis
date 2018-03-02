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

while getopts ":q:p:c:" opt; do
  case $opt in
    q)
      QGIS_BUILD_DIR=$OPTARG
      ;;
    p)
      PACKAGE="--package=$OPTARG"
      ;;
    c)
      CLASS="--class=$OPTARG"
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
  esac
done
shift $(expr $OPTIND - 1)

if [[ -n $QGIS_BUILD_DIR ]]; then
  export PYTHONPATH=$PYTHONPATH:$QGIS_BUILD_DIR/output/python
  #export PATH=$PATH:/usr/local/bin/:$QGIS_BUILD_DIR/build/output/bin
fi
export PYTHONPATH=$PYTHONPATH:${DIR}/..
echo "setting PYTHONPATH $PYTHONPATH"


echo "travis_fold:start:make_api_rst"
echo "make API RST ./rst/make_api_rst.py $PACKAGE $CLASS"
./rst/make_api_rst.py $PACKAGE $CLASS
echo "travis_fold:end:make_api_rst"

echo "travis_fold:start:build_html"
echo "build HTML"
#make html
echo "travis_fold:end:build_html"

popd
