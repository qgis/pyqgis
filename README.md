# QGIS Python API Documentation

Sphinx project to build python API documentation for QGIS

You can see an online version of the generated documentation at this
website:

https://qgis.org/pyqgis/master/index.html

## Prerequisites:

Building and mostly pushing the docs properly requires SIP 4.19.7+.

``pip3 install -r requirements.txt``


## To build:

Call ``build-docs.sh``. QGIS python package must be found.
You can either:

* export the PYTHONPATH yourself
* export your QGIS build directory with ``export QGIS-BUILD-DIR=/Users/timlinux/dev/QGIS/build``
* or provide QGIS build directory as argument to the script: ``./build-docs.sh -qgis-build-dir /Users/timlinux/dev/QGIS/build``

## Viewing the docs

Open the build/html/ contents in your web browser.

e.g. on MacOS you can do ``open open build/html/docs/index.html``

## Publishing the docs

Use the ``publish-docs.sh`` script, with having build the docs before publishing them.

## Credits

- Tim Sutton 2017 - Initial prototype for this build system
- Denis Rouzaud 2017 - Including work funded by QGIS.org
