from unittest import TestCase
from make_api_rst import current_subgroup


class TestCurrentSubGroup(TestCase):

    def test_current_subgroup(self):
        """Test we can extract a subgroup from a class name."""

        class_name = 'QgsComposerItem'
        result = current_subgroup(class_name)
        expected = 'Composer'
        self.assertEqual(result, expected)
