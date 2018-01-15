#!/bin/bash
if [ $# -eq 0 ]
  then
    echo "No arguments supplied"
    echo "Usage:"
    echo "$0 <path to QGIS buid directory>"
    echo "$0 /Users/timlinux/dev/cpp/QGIS-QtCreator-Build"
fi
QGIS_BUILD_DIR=$1

./build-docs.sh $QGIS_BUILD_DIR

mkdir publish
cd publish
git clone git@github.com:qgis/QGISPythonAPIDocumentation.git --depth 1 --branch gh-pages
git rm . -r
cp ../build/html/* . -r
touch .nojekyll
git add -A
git commit -m "Automatic update from https://github.com/qgis/QGISPythonDocumentation/docs/commit/${TRAVIS_COMMIT}"
git push
