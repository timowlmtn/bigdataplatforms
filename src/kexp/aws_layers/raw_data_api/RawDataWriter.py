class RawDataWriter:
    api_reader = None
    data_lake_handler = None

    def __init__(self, api_reader, data_lake_handler):
        self.api_reader = api_reader
        self.data_lake_handler = data_lake_handler

    def write_raw_data(self, raw_data_root):
        start_date = self.data_lake_handler.get_object_last_source_timestamp(raw_data_root)
        if start_date is None:
            start_date = self.api_reader.get_default_start_date()

        return start_date

