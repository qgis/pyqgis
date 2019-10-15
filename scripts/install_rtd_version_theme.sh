#!/usr/bin/env bash

# if making any change here, don't forget to update Dockerfile

git clone --depth 1 https://github.com/3nids/sphinx_rtd_theme.git --branch versioning2
pushd sphinx_rtd_theme
python3 setup.py install


popd