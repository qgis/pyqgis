# creates methods summary
# see https://stackoverflow.com/questions/20569011/python-sphinx-autosummary-automated-listing-of-member-functions
# added toctree and nosignatures in options

from sphinx.ext.autosummary import Autosummary
from sphinx.ext.autosummary import get_documenter
from docutils.parsers.rst import directives
from sphinx.util.inspect import safe_getattr
# from sphinx.directives import directive
import re
import PyQt5
import inspect

class AutoAutoSummary(Autosummary):

    option_spec = {
        'methods': directives.unchanged,
        'signals':  directives.unchanged,
        'attributes': directives.unchanged,
        'nosignatures': directives.unchanged,
        'toctree': directives.unchanged
    }

    required_arguments = 1

    @staticmethod
    def get_members(doc, obj, typ, include_public=None, signal=False):
        try:
            if not include_public:
                include_public = []
            items = []

            for name in dir(obj):
                if name not in obj.__dict__.keys():
                    continue
                try:
                    chobj = safe_getattr(obj, name)
                    documenter = get_documenter(doc.settings.env.app, chobj, obj)
                    # cl = get_class_that_defined_method(chobj)
                    # print(name, type(cl), repr(cl))
                    if documenter.objtype == typ:
                        if typ == 'attribute':
                            if signal and type(chobj) != PyQt5.QtCore.pyqtSignal:
                                continue
                            if not signal and type(chobj) == PyQt5.QtCore.pyqtSignal:
                                continue
                        items.append(name)
                except AttributeError:
                    continue
            public = [x for x in items if x in include_public or not x.startswith('_')]
            return public, items
        except BaseException as e:
            print(str(e))
            raise e

    def run(self):
        clazz = self.arguments[0]
        try:
            (module_name, class_name) = clazz.rsplit('.', 1)
            m = __import__(module_name, globals(), locals(), [class_name])
            c = getattr(m, class_name)
            if 'methods' in self.options:
                _, methods = self.get_members(self.state.document, c, 'method', ['__init__'])
                self.content = ["~%s.%s" % (clazz, method) for method in methods if not method.startswith('_')]
            if 'signals' in self.options:
                x, attribs = self.get_members(self.state.document, c, 'attribute', None, True)
                self.content = ["~%s.%s" % (clazz, attrib) for attrib in attribs if not attrib.startswith('_')]
            if 'attributes' in self.options:
                x, attribs = self.get_members(self.state.document, c, 'attribute', None, False)
                self.content = ["~%s.%s" % (clazz, attrib) for attrib in attribs if not attrib.startswith('_')]
        except BaseException as e:
            print(str(e))
            raise e
        finally:
            return super().run()
