#!/bin/bash

set -e

export PATH=$PATH:/usr/local/bin/:/Users/denis/opt/qgis/QGIS/build/output/bin
export PYTHONPATH=$PYTHONPATH:/Users/denis/opt/qgis/QGIS/build/output/python/

./rst/make_api_rst.py --package gui --class QgsAdvancedDigit
make html -j4

mkdir publish
cd publish
git clone git@github.com:opengisch/QGISPythonAPIDocumentation.git --depth 1 --branch docs
git rm . -r
cp ../build/html/* . -r
touch .nojekyll
git add -A
#git commit -m "Automatic update from https://github.com/qgep/docs/commit/${TRAVIS_COMMIT}"
#git push
