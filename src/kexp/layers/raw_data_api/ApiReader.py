import pytz
from datetime import datetime
from datetime import timedelta
from tzlocal import get_localzone


class ApiReader:
    source_api_url = None
    timezone = None
    datetime_format_api = None

    def __init__(self, source_api_url, timezone='US/Pacific', datetime_format_api="%Y-%m-%dT%H:%M:%S%z"):
        self.source_api_url = source_api_url
        self.timezone = pytz.timezone(timezone)
        self.datetime_format_api = datetime_format_api

    def get_sync_api_calls(self, source_start_date_map, source_end_date, max_rows=100):

        source_date_before_str = datetime.strftime(
            source_end_date, self.datetime_format_api
        )

        api_requests = {
            "hosts": f"{self.source_api_url}/hosts/?limit={max_rows}",
            "programs": f"{self.source_api_url}/programs/?limit={max_rows}",
            "shows": f"{self.source_api_url}"
                     f"/shows/?start_time_before={source_date_before_str}"
                     f"&start_time_after={datetime.strftime(source_start_date_map['shows'], self.datetime_format_api)}"
                     f"&limit={max_rows}",
            "plays": f"{self.source_api_url}"
                     f"/plays/?airdate_before={source_date_before_str}"
                     f"&airdate_after={datetime.strftime(source_start_date_map['plays'], self.datetime_format_api)}"
                     f"&limit={max_rows}",
            "timeslots": f"{self.source_api_url}"
                         f"/timeslots/?start_time_before={source_date_before_str}"
                         f"&start_time_after="
                         f"{datetime.strftime(source_start_date_map['timeslots'], self.datetime_format_api)}"
                         f"&limit={max_rows}"
        }

        return api_requests

    def get_default_start_date(self, date_timestamp):
        if date_timestamp is None:
            now_pst = datetime.now(tz=self.timezone)
            return now_pst - timedelta(days=1)
        else:
            current_tz = get_localzone()
            target_dt = current_tz.localize(date_timestamp).astimezone(self.timezone)
            return target_dt

    def get_default_end_date(self):
        return datetime.now(tz=self.timezone)

    @staticmethod
    def get_start_time_keys():
        start_times = {
            "hosts": None,
            "programs": None,
            "shows": "start_time",
            "plays": "airdate",
            "timeslots": None
        }

        return start_times
