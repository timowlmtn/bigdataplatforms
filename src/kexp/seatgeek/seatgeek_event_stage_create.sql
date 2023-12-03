create or replace stage LANDING_ZONE.STAGE_SEATGEEK_EVENT
storage_integration=OWLMTN_STORAGE_INTEGRATION_DATA_LAKE_DEV
url = 's3://owlmtn-datalake-dev/stage/seatgeek/events/';
