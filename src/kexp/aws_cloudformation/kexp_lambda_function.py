import lakelayer

import boto3
import logging
import os

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
        playlist_map = kexp_reader.get_playlist(airdate_after_date=kexp_lake.get_newest_playlist_date(),
                                                airdate_before_date=datetime.now())
        kexp_lake.put_playlist(playlist_map)
        kexp_lake.put_shows(kexp_reader.get_shows(playlist_map))

        result = {"playlist": kexp_playlists}
        return result

    except Exception as exception:
        message = f"ERROR in {context.function_name}: {exception} {traceback_output}"
        logger.error(message)
        raise





