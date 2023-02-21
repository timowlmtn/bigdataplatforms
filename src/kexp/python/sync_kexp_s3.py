import logging
import json
import os

import lakelayer

logger = logging.getLogger()
logger.setLevel(logging.INFO)
global_error = None


def main():
    if os.getenv("ExportBucket") is None or os.getenv("ExportStage") is None:
        print("Need to set ExportBucket to be the AWS Bucket configured for Snowflake")
        print("and the stage folder configured in the Snowflake Storage Integration")
    else:
        print(f'Running with {os.getenv("ExportBucket")} and {os.getenv("ExportStage")}')
        # print(json.dumps(lakelayer.sync_kexp_s3(), indent=2))
        print(json.dumps(lakelayer.sync_django_s3(), indent=2))


if __name__ == "__main__":
    main()

