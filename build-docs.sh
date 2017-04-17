#!/bin/bash
#Shamelessly hard coding paths for now....
# Assume brew installed deps
export PATH=$PATH:/usr/local/bin/:/Users/timlinux/dev/cpp/QGIS-QtCreator-Build/output/bin
PYTHONPATH=$PYTHONPATH:/Users/timlinux/dev/cpp/QGIS-QtCreator-Build/output/python/
export PYTHONPATH

make test
rm -rf _build/*
rm *.rst
./make_api_rst.py
make html
open _build/html/docs/index.html
cp -r themes/qgis-theme/static/ _build/html/_static
cd _build
rsync -av html mountain:/home/timlinux/QGISPythonDocumentation
cd -
