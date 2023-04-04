from botocore.exceptions import ClientError
import traceback
import re
from datetime import datetime


class DataLakeHandler:
    s3_client = None
    s3_bucket = None
    s3_stage = None

    datetime_format_lake = None

    def __init__(self, s3_client, s3_bucket, s3_stage, datetime_format_lake="%Y%m%d%H%M%S"):
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
        self.datetime_format_lake = datetime_format_lake

    def list_objects(self, prefix):
        """
        Fundamental interface with the S3 client.  This will return a list of objects from S3.

        :param prefix:
        :return:
        """
        try:
            result = []

            paginator = self.s3_client.get_paginator('list_objects_v2')
            pages = paginator.paginate(Bucket=self.s3_bucket, Prefix=prefix)

            for page in pages:
                if 'Contents' in page:
                    for obj in page['Contents']:
                        result.append(obj)

            return result

        except ClientError as exc:
            raise ValueError(f"Failed to read: {self.s3_bucket} {self.s3_stage}: {exc}\n{traceback.format_exc()}")

    def get_object_last_source_timestamp(self, prefix):
        list_objects = self.list_objects(f"s3://{self.s3_bucket}/{prefix}")
        if len(list_objects) > 0:
            return list_objects[0]
        else:
            return None

    def get_raw_folders(self, default_end_date):

        airdate_after_str = datetime.strftime(default_end_date, self.datetime_format_lake)

        regexp = r"([\d]{4})([\d]{2})([\d]{2}).*"
        match = re.match(regexp, airdate_after_str)

        template = f"{self.s3_stage}/template/{match.group(1)}/{match.group(2)}/{match.group(3)}/" \
                   f"{airdate_after_str}"

        keys = ["hosts", "programs", "shows", "plays", "timeslots"]
        raw_output = {}
        for key in keys:
            raw_output[key] = template.replace("template", key)

        return raw_output

    def get_root_folder(self):
        return f"s3://{self.s3_bucket}/{self.s3_stage}"
