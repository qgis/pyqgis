#!/usr/bin/env bash

git clone --depth 1 https://github.com/3nids/sphinx_rtd_theme.git --branch versioning
pushd sphinx_rtd_theme
python3 setup.py install


popd