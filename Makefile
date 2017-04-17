#/***************************************************************************
#
# QGIS Python Documentation Generator
#                             -------------------
#        begin                : 2017-04-14
#        copyright            : (C) 2017 by Tim Sutton
#        email                : tim@qgis.org
# ***************************************************************************/
#
#/***************************************************************************
# *                                                                         *
# *   This program is free software; you can redistribute it and/or modify  *
# *   it under the terms of the GNU General Public License as published by  *
# *   the Free Software Foundation; either version 2 of the License, or     *
# *   (at your option) any later version.                                   *
# *                                                                         *
# ***************************************************************************/

# Makefile for InaSAFE - QGIS
SHELL := /bin/bash
DIR := ${CURDIR}

default: test

clean:
	@# Preceding dash means that make will continue in case of errors
	@-find . -name '*~' -exec rm {} \;
	@-find . -name '*.pyc' -exec rm {} \;
	@-find . -name '*.pyo' -exec rm {} \;
	@# Clean stray merge working files from git
	@-find . -name '*.orig' -exec rm {} \;
	@-/bin/rm .noseids 2>/dev/null || true
	@-/bin/rm .coverage 2>/dev/null || true
	@-/bin/rm -rf docs 2>/dev/null || true

test: pep8 pylint test_suite

test_suite:
	@-export PYTHONPATH=`pwd`:$(PYTHONPATH); nosetests -v .

pep8:
	@echo
	@echo "-----------"
	@echo "PEP8 issues"
	@echo "-----------"
	@pep8 --version
	@pep8 --repeat --ignore=E203,E121,E122,E123,E124,E125,E126,E127,E128,E402 --exclude venv,pydev,conf.py . || true

pylint:
	@echo
	@echo "-----------------"
	@echo "Pylint violations"
	@echo "-----------------"
	@pylint --version
	@pylint --reports=n --rcfile=pylintrc . || true
