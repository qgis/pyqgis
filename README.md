# QGIS Python API Documentation

Sphinx project to build python API documentation for QGIS

You can see an online version of the generated documentation at this temporary
website -

https://qgis.github.io/QGISPythonAPIDocumentation/api/index.html.

## Prerequisites:

pip3 install sphinx
pip3 install -r requirements.txt 


## To build:

Call ``build-docs.sh`` providing the path to you QGIS build dir as appropriate.

e.g. ``./build-docs.sh /Users/timlinux/dev/cpp/QGIS-QtCreator-Build``

## Viewing the docs

Open the build/html/ contents in your web browser.

e.g. on MacOS you can do ``open open build/html/docs/index.html``

## Publishing the docs

Use the ``publish-docs.sh`` script, providing the path to you QGIS build dir as
appropriate.

e.g. ``./publish-docs.sh /Users/timlinux/dev/cpp/QGIS-QtCreator-Build``

## Credits

Tim Sutton 2017 - Initial prototype for this build system
Denis Rouzaud 2017 - Including work funded by QGIS.org
