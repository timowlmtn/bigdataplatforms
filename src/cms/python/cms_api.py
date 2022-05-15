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
import argparse
import datetime
import json
import os

from cms_api import CmsApiReader

if __name__ == "__main__":
    parser = argparse.ArgumentParser("Input the parameters")
    parser.add_argument("--dataset", help="A dataset ID", default="4pq5-n9py")
    parser.add_argument("--name", help="Dataset Name", default="provider")

    parser.add_argument("--index", help="The index of a distribution in a dataset's distribution array. For instance, "
                                        "the first distribution in a dataset would have an index of \"0,\" the "
                                        "second would have \"1\", etc.", default=0)
    parser.add_argument("--dryrun", help="True or False to indicate whether to write or not", action='store_true')
    args = parser.parse_args()

    now = datetime.datetime.now()
    directory = f"{os.getenv('DATA_HOME')}/{args.name}/" \
                f"{now.strftime('%Y')}/{now.strftime('%m')}/{now.strftime('%d')}/" \
                f"{now.strftime('%y%m%d%H%M%S')}"

    print(f"Writing to: {directory}")

    cms_reader = CmsApiReader(directory, f"DAC_NationalDownloadableFile_{args.index}", args.dryrun)

    result = cms_reader.write_json(args.dataset, args.index, cms_reader.default_params)


