import unittest


class StudyListTest(unittest.TestCase):

    def test_how_many_friends(self):
        friend_map = {}
        friend_array = [[2, 3], [3, 4], [5]]
        for row in friend_array:
            current_friends = set()
            for col in row:
                current_friends.add(col)
                if col not in friend_map:
                    friend_map[col] = current_friends
                friend_map[col].add(col)
                print(col)
                print(friend_map)

        print(friend_map)

        friend_count = {}
        for key in friend_map:
            friend_count[key] = len(friend_map[key]) - 1

        self.assertEqual({2: 1, 3: 1, 4: 1, 5: 0}, friend_count)

    def test_fill_in_nulls(self):
        original_set = [1, None, 1, 2, None]
        last_value = None
        result = []
        for key in original_set:
            if key is not None:
                result.append(key)
            else:
                result.append(last_value)
            last_value = key

        self.assertEqual([1, 1, 1, 2, 2], result)

    def test_mismatched_words(self):
        string_1 = "Firstly this is the first string"
        string_array_2 = "Next is the second string".split(" ")

        mismatched = set()
        for idx, element in enumerate(string_1.split(" ")):
            print(f"{idx} {element}")
            mismatched.add(element)

        for element in string_array_2:
            if element in mismatched:
                mismatched.remove(element)
            else:
                mismatched.add(element)

        self.assertEqual({'Firstly', 'this', 'Next', 'first', 'second'}, mismatched)

    def test_count_characters(self):
        character = 's'
        word = "mississippi"
        count = 0
        for element in word:
            if element == character:
                count += 1

        self.assertEqual(4, count)

    @staticmethod
    def check_test(check_string) -> bool:
        matched_values = list()
        for element in check_string:
            # print(matched_values)
            if element == '(':
                matched_values.append("(")
            elif len(matched_values) > 0 and element == ')':
                matched_values.pop(len(matched_values) - 1)

        return len(matched_values) == 0

    def test_mismatched_parenthesis(self):
        self.assertEqual(True, self.check_test("(a(b)c)"))
        self.assertEqual(True, self.check_test("(a)(c)"))
        self.assertEqual(False, self.check_test("(a))((c)"))

    def test_check_monotonic_array(self):
        def check_monotonic(array) -> bool:
            result = True
            if len(array) > 1:
                value_last = array[0]
                for idx in range(1, len(array)):
                    if value_last > array[idx]:
                        result = False
                        break
                    value_last = array[idx]

            return result

        self.assertTrue(check_monotonic(array=[1, 2, 3, 4]))
        self.assertFalse(check_monotonic(array=[1, 2, 65, 4]))

    def test_check_ip_ok(self):
        def check_is_ip(string_in) -> bool:
            four_values = string_in.split('.')
            result = False
            if len(four_values) == 4:
                for value in four_values:
                    if value.isnumeric() and int(value) > 256:
                        result = False
                        break
                    elif value.isnumeric() is False:
                        result = False
                        break
                    else:
                        result = True

            return result

        self.assertTrue(check_is_ip("128.10.54.22"))
        self.assertFalse(check_is_ip("128.10a.54.22"))
        self.assertFalse(check_is_ip("128.459.54.22"))

    def test_count_nodes(self):
        symmetric_graph = [[1, 1, 0],
                           [1, 1, 0],
                           [0, 0, 1]]

        symmetric_graph_2 = [[1, 1, 0, 1],
                             [1, 1, 0, 0],
                             [0, 0, 1, 0],
                             [1, 0, 0, 1]]

        def count_neighbors(input_graph):
            result = len(input_graph) * [0]

            for idx in range(0, len(input_graph)):
                for col in range(idx+1, len(input_graph)):
                    result[col] = input_graph[idx][col]
                    result[idx] = sum(input_graph[idx])-1
                    print(f"{idx} {col} | {input_graph[idx][col]} {result}")
            print('***')

            return result

        print("---")
        self.assertEqual([1, 1, 0], count_neighbors(symmetric_graph))
        self.assertEqual([2, 1, 0, 1], count_neighbors(symmetric_graph_2))
