#!/usr/local/bin/python3
# coding=utf-8

from string import Template
from os import mkdir

import re
from qgis import core, gui, analysis
from shutil import rmtree

index = open('docs/index.rst', 'w')
header = """
Welcome to the QGIS Python API documentation project!
==============================================================

.. toctree::
   :maxdepth: 2
   :numbered:
   :caption: Contents:

"""

# Read in the standard rst template we will use for classes
index.write(header)
with open('qgis_pydoc_template.txt', 'r') as template_file:
    template_text = template_file.read()

template = Template(template_text)

rmtree('docs', ignore_errors=True)
mkdir('docs')

# Iterate over every class in every package and write out an rst
# template based on standard rst template
groups = {'core': core, 'gui': gui, 'analysis': analysis}
for group, package in groups.items():
    classes = dir(package)
    mkdir('docs/%s' % group)
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
        core_rst = open('docs/%s/%s.rst' % (group, class_name), 'w')
        print(class_template, file=core_rst)
        core_rst.close()
        index.write('   %s/%s\n' % (group, class_name))


index.write("""
Indices and tables
==================

* :ref:`genindex`
* :ref:`modindex`
* :ref:`search`""")
index.close()


def current_subgroup(class_name):
    """A helper to determine the current subgroup given the class name.

    For example we want to know if we are dealing with the composer classes,
    the geometry classes etc. In the case of QgsComposerStyle the extracted
    subgroup would be 'Composer'.

    :param class_name: The class name that we want to extract the subgroup
        name for. e.g. 'QgsComposerStyle'
    :type class_name: str

    :returns: The subgroup name e.g. 'Composer'
    """
    stripped_prefix = class_name.replace('Qgs', '')
    first_word = re.search('^[A-Z][a-z]*', stripped_prefix).group(0)
    return first_word
