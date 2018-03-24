#!/usr/bin/env bash

set -e

# https://stackoverflow.com/questions/16989598/bash-comparing-version-numbers
function version_gt() { test "$(printf '%s\n' "$@" | sort -V | head -n 1)" != "$1"; }
if version_gt '4.19.7' $(sip -V); then
     echo "Your version of SIP is too old. SIP 4.19.7+ is required"
     exit 1
fi

echo "*** Create publish directory"
mkdir -p publish
rm -rf publish/*
pushd publish

echo "*** Clone gh-pages branch"
git clone git@github.com:qgis/QGISPythonAPIDocumentation.git --depth 1 --branch gh-pages
pushd QGISPythonAPIDocumentation
rm -rf $QGIS_VERSION
mkdir $QGIS_VERSION
cp -R ../../build/${QGIS_VERSION}/html/* ${QGIS_VERSION}/

echo "*** Add and push"
git add --all
git commit -m "Update docs for QGIS ${QGIS_VERSION}"
if [[ $TRAVIS == true ]]; then
  git push
else
  read -p "Are you sure to push? (y/n)" -n 1 -r response
  echo    # (optional) move to a new line
  if [[ $response =~ ^[Yy](es)?$ ]]
  then
      git push
  fi
fi

popd
popd
rm -rf publish/*
