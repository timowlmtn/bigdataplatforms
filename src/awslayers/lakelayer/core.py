from botocore.exceptions import ClientError
from datetime import datetime
import json
import mimetypes
import re
import requests
import traceback

kexp_max_rows = 1000


class KexpDataLake:
    s3_client = None
    s3_bucket = None
    s3_stage = None
    playlist_regexp = None

    def __init__(self, s3_client, s3_bucket, s3_stage):
        self.s3_client = s3_client
        self.s3_bucket = s3_bucket
        self.s3_stage = s3_stage
        self.playlist_regexp = re.compile(f"{self.s3_stage}/playlists/([\\d]+)/playlist.*.json")

    def list_playlists(self):
        return self.list_object_results(f"{self.s3_stage}/playlists")

    def list_shows(self):
        return self.list_object_results(f"{self.s3_stage}/shows")

    def list_object_results(self, prefix):
        try:
            return self.s3_client.list_objects_v2(Bucket=self.s3_bucket,
                                                  MaxKeys=kexp_max_rows,
                                                  Prefix=prefix)['Contents']

        except ClientError as exc:
            raise ValueError(f"Failed to read: {self.s3_bucket} {self.s3_stage}: {exc}\n{traceback.format_exc()}")

    def get_newest_playlist(self):
        """
        Get the newest playlist date using the fact that AWS always lists alphabetically.
        :return:
        """
        playlists = self.list_playlists()
        return self.list_playlists()[len(playlists)-1]

    def get_oldest_playlist_key(self):
        oldest_playlist = self.get_oldest_playlist()
        match = re.match(self.playlist_regexp, oldest_playlist["Key"])
        return match.group(1)

    def get_newest_playlist_key(self):
        newest_playlist = self.get_newest_playlist()
        match = re.match(self.playlist_regexp, newest_playlist["Key"])
        return match.group(1)

    def get_oldest_playlist(self):
        """
        Get the oldest playlist date using the fact that AWS always lists alphabetically.
        :return:
        """
        return self.list_playlists()[0]

    def get_playlist_object_map(self):
        result = {}
        key_regexp = re.compile(f"{self.s3_stage}/playlists/([\\d]+)/playlist.*.json")
        for list_object in self.list_object_results(f"{self.s3_stage}/playlists"):
            match = re.match(key_regexp, list_object["Key"])
            if match:
                result[match.group(1)] = list_object
            else:
                raise ValueError(f"Failed to match {list_object} with {key_regexp}")

        return result

    def put_object(self, key, contents):
        mimetype, _ = mimetypes.guess_type(key)
        self.s3_client.put_object(Bucket=self.s3_bucket,
                                  Key=key,
                                  Body=contents,
                                  ContentType=mimetype)

    def put_playlist(self, json_playlist_map):
        for timestamp in json_playlist_map.keys():
            key = f"{self.s3_stage}/playlists/{timestamp}/playlist{json_playlist_map[timestamp]['id']}.json"
            self.put_object(key, json.dumps(json_playlist_map[timestamp]))

    def put_shows(self, json_shows_map):
        for show_id in json_shows_map.keys():
            key = f"{self.s3_stage}/shows/{show_id}/show{json_shows_map[show_id]['id']}.json"
            self.put_object(key, json.dumps(json_shows_map[show_id]))


class KexpApiReader:
    airdate_before_date = None

    datetime_format_api = "%Y-%m-%dT%H:%M:%S%z"
    datetime_format_lake = "%Y%m%d%H%M%S"

    def date_to_api(self):
        return datetime.strftime(self.airdate_before_date, self.datetime_format_api)

    def get_playlist(self, read_rows=kexp_max_rows, airdate_before=None):
        if airdate_before is None:
            airdate_before_str = datetime.strftime(datetime.now(), self.datetime_format_api)
        else:
            airdate_before_str = datetime.strftime(
                datetime.strptime(airdate_before, self.datetime_format_lake),
                self.datetime_format_api
            )

        playlist_json = f"https://api.kexp.org/" \
                        f"v2/plays/?format=json&" \
                        f"limit={read_rows}&ordering=-airdate&airdate_before={airdate_before_str}"

        page = requests.get(playlist_json)

        # Return the result as an ordered hash map by air date.
        result = {}
        for playlist_obj in json.loads(page.text)["results"]:
            air_date = datetime.strptime(playlist_obj["airdate"], self.datetime_format_api)
            result[int(datetime.strftime(air_date, self.datetime_format_lake))] = playlist_obj

        return result

    def get_shows(self, playlist_map):
        """
        Get a list of the shows given a playlist map
        :param playlist_obj:
        :return:
        """
        # Initialize the shows list
        shows_map = {}

        for playlist_key in playlist_map:
            playlist_obj = playlist_map[playlist_key]
            if playlist_obj["show"] not in shows_map:
                shows_map[playlist_obj["show"]] = None

        for show in shows_map:
            if shows_map[show] is None:
                page = requests.get(f"https://api.kexp.org/v2/shows/{show}/?format=json")
                shows_map[show] = json.loads(page.text)

        return shows_map
