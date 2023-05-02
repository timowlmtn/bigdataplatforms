import unittest


class DictionaryTest(unittest.TestCase):

    def test_sort_dictionary(self):
        dictionary = {
            "a": 1,
            "b": 2,
            "c": 0
        }

        sorted_candidates = sorted(dictionary.items(), key=lambda key: key[1])

        print(sorted_candidates)
        n = 2
        self.assertEqual(('a', 1), sorted_candidates[n - 1])

    def test_flatten_nested_dictionary(self):
        nested_dictionary = {
            "a": {
                "b": 1,
                "c": 2,
                "d": {
                    "e": 0
                }
            },
            "f": 3
        }

        def flatten_level(dictionary):
            flatten_result = {}
            for key in dictionary:
                if type(dictionary[key]) is dict:
                    flatten_result[key] = dictionary[key]
                    flatten_result.update(flatten_level(dictionary[key]))
                else:
                    flatten_result[key] = dictionary[key]

            return flatten_result

        result = flatten_level(nested_dictionary)
        self.assertEqual({'a': {'b': 1, 'c': 2, 'd': {'e': 0}},
                          'b': 1,
                          'c': 2,
                          'd': {'e': 0},
                          'e': 0,
                          'f': 3}, result)
