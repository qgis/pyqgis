#!/usr/local/bin/python3

from qgis import core, gui
index = open('docs/index.rst', 'w')
header = """
Welcome to QGIS's documentation!
================================

.. toctree::
   :maxdepth: 2
   :caption: Contents:

"""
index.write(header)


classes = dir(core)
for class_name in classes:
    prefix = class_name[0:3]
    if prefix != 'Qgs':
        continue
    print(class_name)
    template = """
Package: qgis\.core
----------------------------

Class: %(CLASS)s
=============================

.. autoclass:: qgis.core.%(CLASS)s
   :members:
   :undoc-members:
   :show-inheritance:""" % {
    'CLASS': class_name
        }
    core_rst = open('docs/%s.rst' % class_name, 'w')
    print(template, file=core_rst)
    core_rst.close()
    index.write('   %s\n' % class_name)

classes = dir(gui)
for class_name in classes:
    prefix = class_name[0:3]
    if prefix != 'Qgs':
        continue
    print(class_name)
    template = """
Package: qgis\.gui
----------------------------

Class: %(CLASS)s
=============================

.. autoclass:: qgis.gui.%(CLASS)s
   :members:
   :undoc-members:
   :show-inheritance:""" % {
   'CLASS': class_name
    }
    gui_rst = open('docs/%s.rst' % class_name, 'w')
    print(template, file=gui_rst)
    gui_rst.close()
    index.write('   %s\n' % class_name)

index.write("""
Indices and tables
==================

* :ref:`genindex`
* :ref:`modindex`
* :ref:`search`""")
index.close()
