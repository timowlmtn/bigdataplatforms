import re
import unittest
import urllib
import os
import json
import requests
from bs4 import BeautifulSoup
from datetime import datetime

class ScrapeKexpPlaylist(unittest.TestCase):
    playlist_url = "https://www.kexp.org/playlist/"
    playlist_json = "https://api.kexp.org/v2/plays/?format=json&limit=10&ordering=-airdate"
    # &airdate_before=2021-09-28T11:53:50.000Z"

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

    def test_get_playlist_api(self):
        page = requests.get(self.playlist_json)

        json_response = json.loads(page.text)

        # Create a unique folder for each request data lake style
        file_directory = f"data/kexp/{datetime.today().strftime('%Y%m%d%H%M%S')}"

        os.makedirs(file_directory)

        with open(f"{file_directory}/playlist.json", "w") as file_out:
            file_out.write(json.dumps(json_response, indent=2, sort_keys=True))


if __name__ == '__main__':
    unittest.main()
