##
# This Makefile gets CMS data from Snowflake and prepares it for Tableau Upload
#
# It is used to upload to Tableau
#
# Author: Tim Burns		Date: 5/8/2022
default: get-export

clean:
	rm -f  data/export/*.csv.gz

get-export-s3:
	aws s3 sync s3://owlmtn-stage-data/stage/cms/export/ ${DATA_HOME}/export

translate-comma:
	sed 's/\\,/,/g' ${DATA_HOME}/export/import_cms_provider_header_0_0_0.csv > ${DATA_HOME}/export/import_provider_header.csv

concatenate-data:
	cat ${DATA_HOME}/export/import_provider_header.csv \
		${DATA_HOME}/export/import_cms_provider_0_*.csv  > ${DATA_HOME}/export/import_cms_provider.csv

get-export: clean get-export-s3 translate-comma concatenat-data

get-schemas:
	curl -X 'GET' 'https://data.cms.gov/provider-data/api/1/metastore/schemas' -H 'accept: application/json' \
		> ${DATA_HOME}/source/provider-data-schemas.json

convert-dd:
	python python/raw_dd_to_json.py \
			--in_csv config/source/provider/DAC_NationalDoctorsAndClinicians_DataDictionary.csv \
			--out_json data/source/provider/DAC_NationalDoctorsAndClinicians_DataDictionary.json

clean-s3:
	aws s3 rm  s3://${EXPORT_BUCKET}/stage/cms --recursive --dryrun

sync-s3:
	aws s3 sync ${DATA_HOME} s3://${EXPORT_BUCKET}/stage/cms --exclude="*" \
		--include="*DAC_NationalDownloadableFile.csv.gz" # --dryrun

create-stage: create-provider-stage

create-schema: create-provider-stage create-statistics-table create-provider create-provider-dim

create-statistics-table:
	snowsql -f sql/ddl/STAGE/tables/copy_statistics_create.sql

create-provider: create-provider-table

create-provider-table:
	snowsql -f sql/ddl/STAGE/tables/cms_provider_table_create.sql

create-provider-stage:
	snowsql -D STORAGE_INTEGRATION_NAME=${CMS_STORAGE_INTEGRATION} \
	 		-D EXPORT_BUCKET=${EXPORT_BUCKET}  \
	 		-f sql/ddl/STAGE/tables/cms_provider_stage_create.sql -o log_level=DEBUG

create-provider-dim:
	snowsql -f sql/ddl/WAREHOUSE/tables/provider_dim_create.sql


pipeline:
	snowsql -f sql/pipeline/STAGE/tables/cms_provider_copy.sql
	snowsql -f sql/pipeline/WAREHOUSE/tables/provider_dim_merge.sql
	snowsql -f sql/pipeline/WAREHOUSE/tables/provider_dim_update.sql

get-api-datastore-imports:
	curl -X 'GET' \
	  'https://data.cms.gov/provider-data/api/1/datastore/imports/26a87e89-7652-5a97-9c0f-5c5712c8d4f5' \
	  -H 'accept: application/json'

get-api-provider:
	python python/cms_api.py --dataset mj5m-pzi6 # --dryrun
