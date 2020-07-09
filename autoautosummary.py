# creates methods summary
# see https://stackoverflow.com/questions/20569011/python-sphinx-autosummary-automated-listing-of-member-functions
# added toctree and nosignatures in options

from sphinx.ext.autosummary import Autosummary
from sphinx.ext.autosummary import get_documenter
from docutils.parsers.rst import directives
from sphinx.util.inspect import safe_getattr
# from sphinx.directives import directive

import PyQt5
from docutils import nodes
from enum import Enum


class AutoAutoSummary(Autosummary):
    """
    Create a summary for methods, attributes and signals (autosummary).

    If the summary contains elements, a title (Methods, Attributes or Signals)
    is automatically added before (using the rubric directive).

    see https://stackoverflow.com/questions/20569011/python-sphinx-autosummary-automated-listing-of-member-functions
    """
    option_spec = {
        'methods': directives.unchanged,
        'signals':  directives.unchanged,
        'enums': directives.unchanged,
        'attributes': directives.unchanged,
        'nosignatures': directives.unchanged,
        'toctree': directives.unchanged
    }

    required_arguments = 1

    @staticmethod
    def get_members(doc, obj, typ, include_public=None, signal=False, enum=False):
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
                    #cl = get_class_that_defined_method(chobj)
                    #print(name, chobj.__qualname__, type(chobj), issubclass(chobj, Enum), documenter.objtype)
                    if documenter.objtype == typ:
                        if typ == 'attribute':
                            if signal and type(chobj) != PyQt5.QtCore.pyqtSignal:
                                continue
                            if not signal and type(chobj) == PyQt5.QtCore.pyqtSignal:
                                continue
                            # skip monkey patched enums
                            # the monkeypatched enums coming out of scoped enum inherit Enum
                            # while the standard/old ones do not
                            if hasattr(chobj, '__objclass__') and issubclass(chobj.__objclass__, Enum):
                                continue
                        elif typ == 'class':
                            if enum:
                                if not issubclass(chobj, Enum):
                                    continue
                            if not enum and issubclass(chobj, Enum):
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
        rubric_title = None
        rubric_elems = None
        rubric_public_elems = None
        try:
            (module_name, class_name) = clazz.rsplit('.', 1)
            m = __import__(module_name, globals(), locals(), [class_name])
            c = getattr(m, class_name)
            if 'methods' in self.options:
                rubric_title = 'Methods'
                _, rubric_elems = self.get_members(self.state.document, c, 'method', ['__init__'])
            elif 'enums' in self.options:
                rubric_title = 'Enums'
                _, rubric_elems = self.get_members(self.state.document, c, 'class', None, False, True)
            elif 'signals' in self.options:
                rubric_title = 'Signals'
                _, rubric_elems = self.get_members(self.state.document, c, 'attribute', None, True)
            elif 'attributes' in self.options:
                rubric_title = 'Attributes'
                _, rubric_elems = self.get_members(self.state.document, c, 'attribute', None, False)

            if rubric_elems:
                rubric_public_elems = list(filter(lambda e: not e.startswith('_'), rubric_elems))
                self.content = ["~%s.%s" % (clazz, elem) for elem in rubric_public_elems]
        except BaseException as e:
            print(str(e))
            raise e
        finally:
            # add the title before the return of the run
            ret = super().run()
            if rubric_title:
                if rubric_public_elems and len(rubric_public_elems) > 0:
                    rub = nodes.rubric('', rubric_title)
                    ret.insert(0, rub)
            return ret
