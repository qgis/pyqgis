# QGISPythonAPIDocumentation
Sphinx project to build python API documentation for QGIS

## What it doesn't do:

* This is currently a hack.
* This will not magically document classes - it only shows
whatever has already been documented. Denis Rouzaud has done some 
awesome stuff to generate the SIP bindings which inspired me to 
do this because it is now possible to add nice sphinx style 
annotations to the sip bindings. If you want nicer docs, pitch
in in the C++ header files, or sponsor someone to do it!
* Theme stuff is still somewhat broken
* You need to manually edit some paths in the batch file
* It doesn't yet nicely group everything together by logical groups e.g. all composer stuff etc.


## What it does do:

* Provides a more pythonic set of docs - you no longer have
to uninterpret c++ code documentation into python docs.
* Automatically scans the API (by looking for all 'Qgs' prefixed
classes in the qgis core and gui libs and generates documentation 
for each class it finds.

## Ok stop waffling let me try it:

Edit ``build-docs.sh``, adjusting the paths accordingly.

Run ``./build-docs.sh``.

Open the docs in _build/html/index.html and enjoy.

Tim Sutton, April 2017
