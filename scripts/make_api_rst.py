#!/usr/bin/env python3
# coding=utf-8

from string import Template
from os import makedirs
from shutil import rmtree
import yaml
import argparse

with open('pyqgis_conf.yml', 'r') as f:
    cfg = yaml.safe_load(f)

parser = argparse.ArgumentParser(description='Create RST files for QGIS Python API Documentation')
parser.add_argument('--version', '-v', dest='qgis_version', default="master")
parser.add_argument('--package', '-p', dest='package_limit', default=None, nargs='+',
                    choices=['core', 'gui', 'server', 'analysis', 'processing', '_3d'],
                    help='limit the build of the docs to one package (core, gui, server, analysis, processing, 3d) ')
parser.add_argument('--class', '-c', dest='class_limit', default=None, nargs='+',
                    help='limit the build of the docs to a single class')
args = parser.parse_args()

if args.package_limit:
    packages = args.package_limit
    exec("from qgis import {}".format(', '.join(packages)))
    packages = {pkg: eval(pkg) for pkg in packages}
else:
    from qgis import core, gui, analysis, server, processing, _3d
    packages = {'core': core, 'gui': gui, 'analysis': analysis, 'server': server, 'processing': processing, '_3d': _3d}
 

# Make sure :numbered: is only specified in the top level index - see
# sphinx docs about this.
document_header = """
:tocdepth: 5

Welcome to the QGIS Python API documentation project
==============================================================

Introduction
------------

`QGIS <https://qgis.org>`_ is a user friendly Open Source Geographic Information System (GIS) that runs on Linux, Unix, Mac OSX, and Windows.
QGIS supports vector, raster, and database formats. QGIS is licensed under the GNU General Public License.
QGIS lets you browse and create map data on your computer. It supports many common spatial data formats (e.g. ESRI ShapeFile, GeoPackage, geotiff).
QGIS supports plugins to do things like display tracks from your GPS. QGIS is Open Source software and its free of cost (download here).
We welcome contributions from our user community in the form of code contributions, bug fixes, bug reports, contributed documentation,
advocacy and supporting other users on our mailing lists and forums. Financial contributions are also welcome.

QGIS source code is available at https://github.com/qgis/QGIS.
There is also a `C++ version of the API documentation <https://api.qgis.org>`_ available.

Earlier versions of the API
---------------------------

See `Backwards Incompatible Changes <https://api.qgis.org/api/master/api_break.html>`_ for information about incompatible changes to API between releases.

Earlier versions of the documentation are also available on the QGIS website:
`3.30 <https://qgis.org/pyqgis/3.30>`_,
`3.28 (LTR) <https://qgis.org/pyqgis/3.28>`_,
`3.26 <https://qgis.org/pyqgis/3.26>`_,
`3.24 <https://qgis.org/pyqgis/3.24>`_,
`3.22 (LTR) <https://qgis.org/pyqgis/3.22>`_,
`3.20 <https://qgis.org/pyqgis/3.20>`_,
`3.18 <https://qgis.org/pyqgis/3.18>`_,
`3.16 (LTR) <https://qgis.org/pyqgis/3.16>`_,
`3.14 <https://qgis.org/pyqgis/3.14>`_,
`3.12 <https://qgis.org/pyqgis/3.12>`_,
`3.10 (LTR) <https://qgis.org/pyqgis/3.10>`_,
`3.8 <https://qgis.org/pyqgis/3.8>`_,
`3.6 <https://qgis.org/pyqgis/3.6>`_,
`3.4(LTR) <https://qgis.org/pyqgis/3.4>`_,
`3.2 <https://qgis.org/pyqgis/3.2>`_,
`3.0 <https://qgis.org/pyqgis/3.0>`_,

Communication channels
----------------------

For support we encourage you to join our `mailing lists <https://qgis.org/en/site/forusers/support.html#mailing-lists>`_ for users and developers.
Some QGIS users and developers can also often be found in channels such as Matrix, Telegram,...

Bug Reporting
--------------

If you think you have found a bug, please report it using our `bug tracker <https://github.com/qgis/pyqgis/issues>`_.
When reporting bugs, please be available to follow up on your initial report.


.. toctree::
   :maxdepth: 5
   :caption: Contents:

"""

document_footer = """
Indices and tables
==================

* :ref:`genindex`
* :ref:`modindex`
* :ref:`search`"""

package_header = """

PACKAGENAME
===================================

.. toctree::
   :maxdepth: 4
   :caption: PACKAGENAME:

"""


def generate_docs():
    """Generate RST documentation by introspection of QGIS libs.

    The function will create a docs directory (removing it first if it
    already exists) and then populate it with an autogenerated sphinx
    document hierarchy with one RST document per QGIS class.

    The generated RST documents will be then parsed by sphinx's autodoc
    plugin to extract python API documentation from them.

    After this function has completed, you should run the 'make html'
    sphinx command to generate the actual html output.
    """

    #qgis_version = 'master'
    qgis_version = args.qgis_version

    rmtree('build/{}'.format(qgis_version), ignore_errors=True)
    rmtree('api/{}'.format(qgis_version), ignore_errors=True)
    makedirs('api', exist_ok=True)
    makedirs('api/{}'.format(qgis_version))
    index = open('api/{}/index.rst'.format(qgis_version), 'w')
    # Read in the standard rst template we will use for classes
    index.write(document_header)

    with open('rst/qgis_pydoc_template.txt', 'r') as template_file:
        template_text = template_file.read()
    template = Template(template_text)

    # Iterate over every class in every package and write out an rst
    # template based on standard rst template

    for package_name, package in packages.items():
        makedirs('api/{}/{}'.format(qgis_version, package_name))
        index.write('   {}/index\n'.format(package_name))

        package_index = open('api/{}/{}/index.rst'.format(qgis_version, package_name), 'w')
        # Read in the standard rst template we will use for classes
        package_index.write(package_header.replace('PACKAGENAME', package_name))

        for class_name in extract_package_classes(package):
            print(class_name)
            substitutions = {
                'PACKAGE': package_name,
                'CLASS': class_name
            }
            class_template = template.substitute(**substitutions)
            class_rst = open(
                'api/{}/{}/{}.rst'.format(
                    qgis_version, package_name, class_name
                ), 'w'
            )
            print(class_template, file=class_rst)
            class_rst.close()
            package_index.write('   {}\n'.format(class_name))
        package_index.close()

    index.write(document_footer)
    index.close()


def extract_package_classes(package):
    """Extract the classes from the package provided.

    :param package: The  package to extract groups from e.g. qgis.core.
    :type package: object

    :returns: A list of classes alphabetically ordered.
    :rtype: list
    """
    classes = []

    for class_name in dir(package):
        if class_name.startswith('_'):
            continue
        if args.class_limit:
            found = False
            for _class in args.class_limit:
                if class_name.startswith(_class):
                    found = True
                    break
            if not found:
                continue
        if class_name in cfg['skipped']:
            continue
        # if not re.match('^Qgi?s', class_name):
        #     continue
        classes.append(class_name)

    return sorted(classes)


if __name__ == "__main__":
    generate_docs()
