#!/bin/bash

rm -rf _build/*
rm *.rst
./make_api_rst.py
make html
open _build/html/docs/index.html
