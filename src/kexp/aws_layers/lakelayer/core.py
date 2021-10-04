# ------------------------------------------------
# Api and Data Lake Learning Code
#
#  This program is to help the reader understand how to build a data lake with API data.
#
# ------------------------------------------------
# License: Apache 2.0
# ------------------------------------------------
# Author: Tim Burns
# Copyright: 2021, Big Data Platforms
# Credits: [KEXP and developers]
# Version: 0.0.1
# Mmaintainer: Tim Burns
# Email: timburnsowlmtn@gmail.com
# Status: Demo Code
# ------------------------------------------------

from botocore.exceptions import ClientError
from datetime import datetime
import json
import mimetypes
import re
import requests
import traceback

import logging

logging.basicConfig(level=logging.INFO)

# Max rows is 1000 because AWS has a max row count of 1000 and for networking purposes, 1000 is a very
# good choice of chunk when accessing an API over the internet.
kexp_max_rows = 1000

datetime_format_api = "%Y-%m-%dT%H:%M:%S%z"
datetime_format_lake = "%Y%m%d%H%M%S"


class KexpDataLake:
    s3_client = None
    s3_bucket = None
    s3_stage = None
    playlist_regexp = None

    def __init__(self, s3_client, s3_bucket, s3_stage):
        """
        The Client, Bucket, and Stage are considered stateful and we reuse these values every time
        the KexpDataLake object is called.

        :param s3_client:
        :param s3_bucket:
        :param s3_stage:
        """
        self.s3_client = s3_client
        self.s3_bucket = s3_bucket
        self.s3_stage = s3_stage
        self.playlist_regexp = re.compile(f"{self.s3_stage}/playlists/([\\d]+)/playlist.*.json")

    def list_playlists(self):
        """
        Lists the playlist entries.  Every new song or break has a playlist entry.  The playlist contains
        song, artist, and air date.
        :return:
        """
        return self.list_object_results(f"{self.s3_stage}/playlists")

    def list_shows(self):
        """
        Lists the radio shows.  The show is presented by the DJ and is part of a program and has one or more hosts.

        :return:
        """
        return self.list_object_results(f"{self.s3_stage}/shows")

    def list_object_results(self, prefix):
        """
        Fundamental interface with the S3 client.  This will return a list of objects from S3.

        See: https://boto3.amazonaws.com/v1/documentation/api/latest/reference/services/s3.html#S3.Client.list_objects_v2

        Will return up to 1000 objects per request in ascending order of the key names.

        :param prefix:
        :return:
        """
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
        return self.list_playlists()[len(playlists) - 1]

    def get_oldest_playlist_key(self):
        """
        Returns the oldest key as a numerical value to get the key used in the data lake
            EG:
                s3://azri.us-data/stage/kexp/playlists/20210704225609/

            The key will be 20210704225609.

        :return:
        """
        oldest_playlist = self.get_oldest_playlist()
        match = re.match(self.playlist_regexp, oldest_playlist["Key"])
        return match.group(1)

    def get_oldest_playlist_date(self):
        """
        Return the oldest playlist date to use when getting historical records.

        :return:
        """
        return datetime.strptime(self.get_oldest_playlist_key(), datetime_format_lake)

    def get_newest_playlist_key(self):
        """
        Returns the playlist as a digit key that can be used in the data lake or ordering within a int list.

        :return:
        """
        newest_playlist = self.get_newest_playlist()
        match = re.match(self.playlist_regexp, newest_playlist["Key"])
        return match.group(1)

    def get_newest_playlist_date(self):
        """
        Return the newest data playlist date so that we can get all the songs played between the
        current day and the newest song.

        :return:
        """
        return datetime.strptime(self.get_newest_playlist_key(), datetime_format_lake)

    def get_oldest_playlist(self):
        """
        Get the oldest playlist date using the fact that AWS always lists alphabetically.
        :return:
        """
        return self.list_playlists()[0]

    def get_playlist_object_map(self):
        """
        Match the timestamp digits in the data lake file.

        :return:
        """
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
        """
        Base level put object wrapper that uses mime types to mark so we can view directly in the browser.

        :param key:
        :param contents:
        :return:
        """
        mimetype, _ = mimetypes.guess_type(key)
        self.s3_client.put_object(Bucket=self.s3_bucket,
                                  Key=key,
                                  Body=contents,
                                  ContentType=mimetype)

    def put_playlist(self, json_playlist_map):
        """
        Put the playlist out as a set of JSON object
        :param json_playlist_map:
        :return:
        """
        json_obj = []
        for timestamp in json_playlist_map.keys():
            key = f"{self.s3_stage}/playlists/{timestamp}/playlist{json_playlist_map[timestamp]['id']}.json"
            json_obj.append(json.dumps(json_playlist_map[timestamp]))

        logging.info(f"Writing out {key}")
        # Use the \n delimiter for sets of json objects and put one per whole list
        self.put_object(key, "\n".join(json_obj))

        # Return the location of the output
        return key

    def put_shows(self, json_shows_map):
        """
        Write out the shows to the S3 bucket

        :param json_shows_map:
        :return:
        """
        json_obj = []
        for show_id in json_shows_map.keys():
            key = f"{self.s3_stage}/shows/{show_id}/show{json_shows_map[show_id]['id']}.json"
            json_obj.append(json.dumps(json_shows_map[show_id]))

        # Use a JSON object for efficient backend processing
        logging.info(f"Writing out {key}")
        self.put_object(key, "\n".join(json_obj))

        return key


class KexpApiReader:
    api_endpoint = "https://api.kexp.org/v2"

    def get_playlist(self, read_rows=None, airdate_after_date=None, airdate_before_date=None):
        if airdate_after_date:
            airdate_after_str = datetime.strftime(
                airdate_after_date,
                datetime_format_api
            )

        if airdate_before_date:
            airdate_before_str = datetime.strftime(
                airdate_before_date,
                datetime_format_api
            )

        playlist_json = f"{self.api_endpoint}/plays/?format=json&ordering=-airdate"

        if read_rows:
            playlist_json = playlist_json + f"&limit={read_rows}"
        if airdate_after_date:
            playlist_json = playlist_json + f"&airdate_after={airdate_after_str}"
        if airdate_before_date:
            playlist_json = playlist_json + f"&airdate_before={airdate_before_str}"

        page = requests.get(playlist_json)

        # Return the result as an ordered hash map by air date.
        result = {}
        for playlist_obj in json.loads(page.text)["results"]:
            air_date = datetime.strptime(playlist_obj["airdate"], datetime_format_api)
            result[int(datetime.strftime(air_date, datetime_format_lake))] = playlist_obj

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
                page = requests.get(f"{self.api_endpoint}/shows/{show}/?format=json")
                shows_map[show] = json.loads(page.text)

        return shows_map
