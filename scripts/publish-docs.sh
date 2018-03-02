#!/usr/bin/env bash

set -e

QGISVERSION=$1

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
#git clone git@github.com:qgis/QGISPythonAPIDocumentation.git --depth 1 --branch gh-pages
mkdir QGISPythonAPIDocumentation
pushd QGISPythonAPIDocumentation
git init
git remote add origin git@github.com:qgis/QGISPythonAPIDocumentation.git
git checkout --orphan $QGISVERSION
#git rm -rf . &>/dev/null
touch .nojekyll
cp -R ../../publish-contents/* .
cp -R ../../build/html/* .

echo "*** Add and push"
git add -A
git commit -m "Update docs"
read -p "Are you sure to push? (y/n)" -n 1 -r response
echo    # (optional) move to a new line
if [[ $response =~ ^[Yy](es)?$ ]]
then
    git push -u origin $QGISVERSION
fi

popd
popd
rm -rf publish/*
