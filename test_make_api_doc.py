from unittest import TestCase
from make_api_rst import current_subgroup, extract_package_subgroups
from qgis import core


class TestCurrentSubGroup(TestCase):

    def test_current_subgroup(self):
        """Test we can extract a subgroup from a class name."""

        class_name = 'QgsComposerItem'
        result = current_subgroup(class_name)
        expected = 'Composer'
        self.assertEqual(result, expected)

    def test_extract_package_groups(self):
        """Test we can extract a package groups from a package name."""

        result = extract_package_subgroups(core)
        expected = 'Composer'
        self.assertTrue(expected in result.keys())
