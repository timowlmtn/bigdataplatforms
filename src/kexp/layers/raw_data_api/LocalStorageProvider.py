from datetime import datetime
import os
import re
import json


class LocalStorageProvider:
    root_folder = None
    stage_folder = None

    datetime_format_lake = None

    def __init__(self, root_folder, stage_folder, datetime_format_lake="%Y%m%d%H%M%S"):
        """
        The Client, Bucket, and Stage are considered stateful, and we reuse these values every time
        the KexpDataLake object is called.

        """
        self.root_folder = root_folder
        self.stage_folder = stage_folder
        self.datetime_format_lake = datetime_format_lake

    def list_objects(self, prefix):
        """
        Fundamental interface with the S3 client.  This will return a list of objects from S3.

        :param prefix:
        :return:
        """
        try:
            return os.listdir(f"{self.root_folder}/{self.stage_folder}/{prefix}")
        except FileNotFoundError:
            return None

    def get_object_last_source_timestamp(self, prefix) -> int:
        result = None
        if os.path.exists(prefix):
            mtime = max(os.stat(root).st_mtime for [root, _, _] in os.walk(prefix))
            result = int(datetime.fromtimestamp(mtime).strftime(self.datetime_format_lake))

        return result

    def get_root_folder(self):
        return self.root_folder

    def get_stage_folder(self):
        return f"{self.stage_folder}"

    def put_object(self, file_name, body):
        write_code = 'w'

        file_path = f"{self.root_folder}/{file_name}"
        match = re.match(r"(.*)/(.*)$", file_path)

        folder = match.group(1)

        if not os.path.exists(folder):
            os.makedirs(folder)

        with open(file_path, write_code) as file_out:
            for row in body:
                file_out.write(f"{json.dumps(row)}\n")
