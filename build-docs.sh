#!/bin/bash

set -e

if [ $# -eq 0 ]
  then
    echo "No arguments supplied"
    echo "Usage:"
    echo "$0 <path to QGIS buid directory>"
    echo "$0 /Users/timlinux/dev/cpp/QGIS-QtCreator-Build"
fi
QGIS_BUILD_DIR=$1

export PYTHONPATH=$PYTHONPATH:$QGIS_BUILD_DIR/output/python/:.
export PATH=$PATH:/usr/local/bin/:$QGIS_BUILD_DIR/build/output/bin
export PYTHONPATH=$PYTHONPATH:$QGIS_BUILD_DIR/build/output/python/

./rst/make_api_rst.py --package gui --class QgsAdvancedDigit
make html -j4

