import re
import unittest
import urllib
import requests
from bs4 import BeautifulSoup


class ScrapeKexpPlaylist(unittest.TestCase):
    playlist_url = "https://www.kexp.org/playlist/"
    raw_url = "https://raw.githubusercontent.com/timowlmtn/bigdataplatforms/master/src/kexp/tests/simple.html"

    def test_get_raw(self):
        with urllib.request.urlopen(self.raw_url) as response:
            html = response.read()

        soup = BeautifulSoup(html, 'html.parser')

        self.assertEqual("A simple HTML DOC", soup.title.string)

    def test_get_playlist(self):
        page = requests.get(self.playlist_url)
        soup = BeautifulSoup(page.text, "html.parser")

        # Remove all non-word characters
        self.assertEqual("Playlist", re.sub("\\s", "", soup.title.string))


if __name__ == '__main__':
    unittest.main()
