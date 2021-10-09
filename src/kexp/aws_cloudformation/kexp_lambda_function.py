import lakelayer
from datetime import datetime
from datetime import timedelta
import boto3
import json
import logging
import os
import pytz
import traceback

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

        pacific = pytz.timezone('US/Pacific')
        now_utc = datetime.now(tz=pytz.utc)
        now_pst = now_utc.astimezone(pacific)
        airdate_after_date = kexp_lake.get_newest_playlist_date()
        if airdate_after_date is None:
            airdate_after_date = now_pst - timedelta(days=1)
        else:
            airdate_after_date = pacific.localize(airdate_after_date)

        airdate_before_date = now_pst
        runtime_key = datetime.strftime(now_pst, lakelayer.datetime_format_lake)
        playlist_map = kexp_reader.get_playlist(read_rows=lakelayer.kexp_max_rows,
                                                airdate_after_date=airdate_after_date,
                                                airdate_before_date=airdate_before_date)
        playlist_key = kexp_lake.put_playlist(runtime_key, playlist_map)
        shows_key = kexp_lake.put_shows(runtime_key, kexp_reader.get_shows(playlist_map))

        result = {"airdate_after_date": datetime.strftime(airdate_after_date, lakelayer.datetime_format_api),
                  "airdate_before_date": datetime.strftime(airdate_before_date, lakelayer.datetime_format_api),
                  "run_datetime_key": datetime.strftime(airdate_before_date, lakelayer.datetime_format_lake),
                  "run_date_key": datetime.strftime(airdate_before_date, '%Y%m%d'),
                  "playlist_key": playlist_key,
                  "shows_key": shows_key,
                  "number_songs": len(playlist_map.keys())
                  }

        kexp_lake.put_object(f"{export_stage}/logs/{result['run_date_key']}/api{result['run_datetime_key']}.json",
                             json.dumps(result))

        return result

    except Exception as exception:
        message = f"ERROR in {context.function_name}: {exception} {traceback.format_exc()}"
        logger.error(message)
        raise
