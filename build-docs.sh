#!/bin/bash
#Shamelessly hard coding paths for now....
# Assume brew installed deps
export PATH=$PATH:/usr/local/bin/:/Users/timlinux/dev/cpp/QGIS-QtCreator-Build/output/bin
PYTHONPATH=$PYTHONPATH:/Users/timlinux/dev/cpp/QGIS-QtCreator-Build/output/python/
export PYTHONPATH

make test
./make_api_rst.py
make html
open build/html/docs/index.html
cp -r themes/qgis-theme/static/ build/html/_static
cd build
rsync -av html mountain:/home/timlinux/QGISPythonDocumentation
cd -
