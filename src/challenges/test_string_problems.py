import unittest


class SparkCatalogTest(unittest.TestCase):
    """
    String test class: See
    https://www.teamblind.com/post/New-Year-Gift---Curated-List-of-Top-75-LeetCode-Questions-to-Save-Your-Time-OaM1orEU
    """

    def test_reverse_in_place(self):
        """
        From the way-back machine.

        https://github.com/Yuffster/CircleMUD/blob/12a0cedbb563465029c46de9537c96854bc11610/lib/world/mob/30.mob#L404

        :return:
        """
        test_string = list("beastly fido")

        test_string = [test_string[idx] for idx in range(len(test_string)-1, -1, -1)]

        self.assertEqual("odif yltsaeb", "".join(test_string))

    def string_is_in(self, test_string):
        char_sequence = set()
        start_idx = 0
        result = 0
        for current_idx in range(len(test_string)):
            print(f"{test_string[current_idx]} {char_sequence}")
            while test_string[current_idx] in char_sequence:
                print(f"\t--{char_sequence}")
                char_sequence.remove(test_string[start_idx])
                print(f"\t----{char_sequence}")
                start_idx += 1
            char_sequence.add(test_string[current_idx])
            result = max(result, current_idx - start_idx + 1)

        return result

    def test_longest_string(self):
        """
        Given a string s, find the length of the longest substring
             without repeating characters.


        :return:
        """
        test_string = "Foot Lights and Spot Lights by Otis Skinner"

        print("\n" +test_string)
        print(self.string_is_in(test_string))
