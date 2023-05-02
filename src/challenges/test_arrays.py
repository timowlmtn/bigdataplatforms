import unittest


class ArrayTest(unittest.TestCase):

    def test_return_numbers_add_to_target(self):
        result = None
        test_array = [1, 2, 3]
        test_target = 3

        for idx, candidate in enumerate(test_array):
            for value_idx in range(idx+1, len(test_array)):
                print(test_array[value_idx])
                if candidate + test_array[value_idx] == test_target:
                    result = (candidate, test_array[value_idx])
                    break

        self.assertEqual((1, 2), result)

    def test_maximize_profit(self):
        result = None

        prices = [10.0, 11.0, 9.0]
        for idx, candidate in enumerate(prices):
            for sale_idx in range(idx+1, len(prices)):
                if prices[idx] < prices[sale_idx]:
                    result = (sale_idx, prices[sale_idx])

        self.assertEqual((1, 11.0), result)

    def test_appears_twice(self):
        result = False
        test_array = [12, 3, 4, 5, 12]

        for idx, candidate in enumerate(test_array):
            for is_twice in range(idx+1, len(test_array)):
                if candidate == test_array[is_twice]:
                    result = True

        self.assertEqual(True, result)

