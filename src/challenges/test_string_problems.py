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

