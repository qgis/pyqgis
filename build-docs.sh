#!/bin/bash

set -e

export PATH=$PATH:/usr/local/bin/:/Users/denis/opt/qgis/QGIS/build/output/bin
export PYTHONPATH=$PYTHONPATH:/Users/denis/opt/qgis/QGIS/build/output/python/


./rst/make_api_rst.py
make html -j4
rm -rf docs
cp -R build/html docs
