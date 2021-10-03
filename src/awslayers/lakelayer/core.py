from botocore.exceptions import ClientError
from datetime import datetime
import json
import re
import requests
import traceback

kexp_max_rows = 1000


class KexpDataLake:
    s3_client = None
    s3_bucket = None
    s3_stage = None

    def __init__(self, s3_client, s3_bucket, s3_stage):
        self.s3_client = s3_client
        self.s3_bucket = s3_bucket
        self.s3_stage = s3_stage

    def list_object_results(self):
        try:
            return self.s3_client.list_objects_v2(Bucket=self.s3_bucket,
                                                  MaxKeys=kexp_max_rows,
                                                  Prefix=self.s3_stage)['Contents']

        except ClientError as exc:
            raise ValueError(f"Failed to read: {self.s3_bucket} {self.s3_stage}: {exc}\n{traceback.format_exc()}")

    def get_playlist_object_map(self):
        result = {}
        key_regexp = r"^[\w]+/[\w]+/([\d]+)/playlist.json"
        for list_object in self.list_object_results():
            print(list_object)
            match = re.match(key_regexp, list_object["Key"])
            if match:
                result[match.group(1)] = list_object
            else:
                raise ValueError(f"Failed to match {list_object} with {key_regexp}")

        return result

    def put_playlist(self, json_playlist_map):
        for timestamp in json_playlist_map.keys():
            key = f"{self.s3_stage}/{timestamp}/playlist.json"

            self.s3_client.put_object(Bucket=self.s3_bucket,
                                      Key=key,
                                      Body=json.dumps(json_playlist_map[timestamp]))


class KexpApiReader:
    airdate_before_date = None

    datetime_format_api = "%Y-%m-%dT%H:%M:%S%z"
    datetime_format_lake = "%Y%m%d%H%M%S"

    # Getting the playlist will populate the dependent values shows
    shows_map = {}

    def __init__(self, airdate_before_date=datetime.now()):
        self.airdate_before_date = airdate_before_date

    def date_to_api(self):
        return datetime.strftime(self.airdate_before_date, self.datetime_format_api)

    def get_playlist(self, read_rows=kexp_max_rows):

        playlist_json = f"https://api.kexp.org/" \
                        f"v2/plays/?format=json&" \
                        f"limit={read_rows}&ordering=-airdate&airdate_before={self.date_to_api()}"

        page = requests.get(playlist_json)

        # Return the result as an ordered hash map by air date.
        result = {}
        for playlist_obj in json.loads(page.text)["results"]:
            air_date = datetime.strptime(playlist_obj["airdate"], self.datetime_format_api)
            result[int(datetime.strftime(air_date, self.datetime_format_lake))] = playlist_obj

            # Initialize the shows list
            if playlist_obj["show"] not in self.shows_map:
                self.shows_map[ playlist_obj["show"]] = None

        return result

    def get_shows(self):
        for show in self.shows_map:
            if self.shows_map[show] is None:
                page = requests.get(f"https://api.kexp.org/v2/shows/{show}/?format=json")
                self.shows_map[show] = json.loads(page.text)

        return self.shows_map
