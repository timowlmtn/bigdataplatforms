import pytz
from datetime import datetime
from datetime import timedelta


class ApiReader:
    source_api_url = None
    timezone = None
    max_rows = 100
    datetime_format_api = None

    def __init__(self, source_api_url, timezone='US/Pacific', datetime_format_api="%Y-%m-%dT%H:%M:%S%z"):
        self.source_api_url = source_api_url
        self.timezone = pytz.timezone(timezone)
        self.datetime_format_api = datetime_format_api

    def get_sync_api_calls(self, source_start_date):
        airdate_before_str = datetime.strftime(
            source_start_date,
            self.datetime_format_api
        )

        api_requests = {
            # "hosts": f"{self.source_api_url}/hosts/?airdate_before={airdate_before_str}&limit={self.max_rows}",
            # "programs": f"{self.source_api_url}/programs/?airdate_before={airdate_before_str}&limit={self.max_rows}",
            # "shows": f"{self.source_api_url}/shows/?airdate_before={airdate_before_str}&limit={self.max_rows}",
            "plays": f"{self.source_api_url}/plays/?airdate_before={airdate_before_str}&limit={self.max_rows}",
            "timeslots": f"{self.source_api_url}/timeslots/?airdate_before={airdate_before_str}&limit={self.max_rows}"
        }

        return api_requests

    def get_default_start_date(self):
        now_pst = datetime.now(tz=self.timezone)
        return now_pst - timedelta(days=1)

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
