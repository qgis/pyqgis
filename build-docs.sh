#!/bin/bash
#Shamelessly hard coding paths for now....

# Assume brew installed deps
export PATH=$PATH:/usr/local/bin/:/Users/timlinux/dev/cpp/QGIS-QtCreator-Build/output/bin
QGIS_PATH=/Users/timlinux/dev/cpp/QGIS-QtCreator-Build/output/bin/QGIS.app/
export QGIS_PREFIX_PATH=${QGIS_PATH}/contents/MacOS
echo "QGIS PATH: $QGIS_PREFIX_PATH"
PYTHONPATH=$PYTHONPATH:/Users/timlinux/dev/cpp/QGIS-QtCreator-Build/output/python/
export PYTHONPATH
echo "PYTHON PATH: $PYTHONPATH"

rm -rf _build/*
rm *.rst
./make_api_rst.py
make html
open _build/html/docs/index.html
