# ------------------------------------------------
# CMS Public API Interface
#
#  This program provides an actionable interface into the CMS data
#
# ------------------------------------------------
# License: Apache 2.0
# ------------------------------------------------
# Author: Tim Burns
# Copyright: 2021, 2022, The Owl Mountain Institute
# Credits: [CMS and developers]
# Version: 0.0.1
# Mmaintainer: Tim Burns
# Email: timburnsowlmtn@gmail.com
# Status: Demo Code
# ------------------------------------------------
import requests
import json
import logging
import os

class CmsApiReader:
    api_endpoint = "https://data.cms.gov/provider-data/api/1/datastore/query"
    default_params = {"limit": 500, "offset": 0, "max_rows": 2.4e6}
    directory = None
    filename = None
    dryrun = False

    def __init__(self, directory, filename, dryrun):
        self.directory = directory
        self.filename = filename
        self.dryrun = dryrun

    def open_file(self):
        if not self.dryrun:
            if not os.path.exists(self.directory):
                os.makedirs(self.directory)

        return open(f"{self.directory}/{self.filename}.jsonl", "w")

    def write_json(self, dataset_id, index, params):
        limit = params['limit']
        offset = params['offset']
        max_rows = params['max_rows']

        file_out = self.open_file()

        last_count = None

        while offset <= max_rows or last_count is None:

            params_url = f"limit={limit}&offset={offset}&" \
                         f"count=true&results=true&schema=true&keys=true&format=json&rowIds=false"
            api_url = f"{self.api_endpoint}/{dataset_id}/{index}?{params_url}"

            page = requests.get(api_url)

            offset = offset + limit

            if page.status_code == 200:
                if "results" in json.loads(page.text):

                    json_obj = json.loads(page.text)

                    total_count = json_obj["count"]
                    max_rows = total_count
                    last_count = len(json_obj["results"])
                    percentage = "{:.2%}".format(offset / total_count)
                    print(f"\tWriting {offset} of {max_rows} ({percentage}) "
                          f"with last_count={last_count}")

                    for json_line in json_obj["results"]:
                        file_out.write(f"{json.dumps(json_line)}\n")
            else:
                error = f"Invalid url result {api_url} code {page.status_code} {page.text}"
                logging.error(error)
                raise error

        file_out.close()