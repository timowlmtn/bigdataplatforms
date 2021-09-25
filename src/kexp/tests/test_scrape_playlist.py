import re
import unittest
import urllib

from bs4 import BeautifulSoup


class ScrapeKexpPlaylist(unittest.TestCase):
    playlist_url = "https://www.kexp.org/playlist/"

    def test_get_playlist(self):
        with urllib.request.urlopen("https://azri.us/policies/privacy") as response:
            html = response.read()

        soup = BeautifulSoup(html, 'html.parser')


if __name__ == '__main__':
    unittest.main()
