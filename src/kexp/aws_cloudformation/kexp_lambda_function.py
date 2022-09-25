import logging
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
        return lakelayer.sync_kexp_s3()

    except Exception as exception:
        message = f"ERROR in {context.function_name}: {exception} {traceback.format_exc()}"
        logger.error(message)
        raise
