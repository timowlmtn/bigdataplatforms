import logging
import os
import traceback

import boto3

import lakelayer

logger = logging.getLogger()
logger.setLevel(logging.INFO)
global_error = None

try:
    cloudWatch = boto3.client('cloudwatch')
except Exception as global_exc:
    logger.error(global_exc)
    global_error = "ERROR: " + str(global_exc)


def sync_kexp_s3(event, context):
    """
    A Lambda function to synchronize KEXP data

    :param event:
    :param context:
    :return:
    """
    try:
        session = boto3.Session()
        export_bucket = os.getenv("ExportBucket")
        export_stage = os.getenv("ExportStage")

        kexp_lake = lakelayer.KexpDataLake(s3_client=session.client("s3"),
                                           s3_bucket=export_bucket,
                                           s3_stage=export_stage)

        kexp_reader = lakelayer.KexpApiReader()

        (runtime_key, airdate_before_date, airdate_after_date) = kexp_lake.get_airdates()

        playlist_map = kexp_reader.get_playlist(read_rows=lakelayer.kexp_max_rows,
                                                airdate_after_date=airdate_after_date,
                                                airdate_before_date=airdate_before_date)
        shows_map = kexp_reader.get_shows(playlist_map)

        result = kexp_lake.put_data(runtime_key, playlist_map, shows_map, airdate_after_date, airdate_before_date)

        return result

    except Exception as exception:
        message = f"ERROR in {context.function_name}: {exception} {traceback.format_exc()}"
        logger.error(message)
        raise
