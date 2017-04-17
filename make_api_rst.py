#!/usr/local/bin/python3

from string import Template
from qgis import core, gui, analysis

index = open('docs/index.rst', 'w')
header = """
Welcome to the QGIS Python API documentation project!
==============================================================

.. toctree::
   :maxdepth: 2
   :caption: Contents:

"""

# Read in the standard rst template we will use for classes
index.write(header)
with open('qgis_pydoc_template.txt', 'r') as template_file:
    template_text = template_file.read()

template = Template(template_text)

# Iterate over every class in every package and write out an rst
# template based on standard rst template
groups = {'core': core, 'gui': gui, 'analysis': analysis}
for group, package in groups.items():
    classes = dir(package)
    for class_name in classes:
        prefix = class_name[0:3]
        if prefix != 'Qgs':
            continue
        print(class_name)
        substitutions = {
            'GROUP': group,
            'CLASS': class_name
        }
        class_template = template.substitute(**substitutions)
        core_rst = open('docs/%s.rst' % class_name, 'w')
        print(class_template, file=core_rst)
        core_rst.close()
        index.write('   %s\n' % class_name)


index.write("""
Indices and tables
==================

* :ref:`genindex`
* :ref:`modindex`
* :ref:`search`""")
index.close()
