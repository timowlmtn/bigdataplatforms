from botocore.exceptions import ClientError
import traceback
import re
from datetime import datetime


class DataLakeHandler:
    storage_provider = None

    datetime_format_lake = None

    def __init__(self, storage_provider, datetime_format_lake="%Y%m%d%H%M%S"):
        """
        The Client, Bucket, and Stage are considered stateful, and we reuse these values every time
        the KexpDataLake object is called.

        :param s3_client:
        :param s3_bucket:
        :param s3_stage:
        """
        self.storage_provider = storage_provider
        self.datetime_format_lake = datetime_format_lake

    def list_objects(self, prefix):
        """
        Fundamental interface with the S3 client.  This will return a list of objects from S3.

        :param prefix:
        :return:
        """
        return self.storage_provider.list_objects(prefix)

    def get_object_last_source_timestamp(self, prefix):
        return self.storage_provider.get_object_last_source_timestamp(prefix)

    def get_raw_folders(self, default_end_date):

        airdate_after_str = datetime.strftime(default_end_date, self.datetime_format_lake)

        regexp = r"([\d]{4})([\d]{2})([\d]{2}).*"
        match = re.match(regexp, airdate_after_str)

        template = f"{self.storage_provider.get_stage_folder()}/template/{match.group(1)}/{match.group(2)}/{match.group(3)}/" \
                   f"{airdate_after_str}"

        keys = ["hosts", "programs", "shows", "plays", "timeslots"]
        raw_output = {}
        for key in keys:
            raw_output[key] = template.replace("template", key)

        return raw_output

    def get_root_folder(self):
        return self.storage_provider.get_root_folder()

    def get_stage_folder(self):
        return self.storage_provider.get_stage_folder()
