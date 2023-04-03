import logging
import json
import os

import lakelayer

logger = logging.getLogger()
logger.setLevel(logging.INFO)
global_error = None


def main():
    if os.getenv("ExportBucket") is None or os.getenv("ExportStage") is None:
        print("Environment variables ExportBucket are ExportStage are required")
    else:
        print(f'Running with {os.getenv("ExportBucket")} and {os.getenv("ExportStage")}')
        print(json.dumps(lakelayer.sync_django_s3(), indent=2))


if __name__ == "__main__":
    main()

