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
	aws s3 sync s3://owlmtn-stage-data/stage/cms/export/ data/export

translate-comma:
	sed 's/\\,/,/g' data/export/import_cms_provider_header_0_0_0.csv > data/export/import_provider_header.csv

concatenat-data:
	cat data/export/import_provider_header.csv data/export/import_cms_provider_0_*.csv > data/export/import_cms_provider.csv

get-export: clean get-export-s3 translate-comma concatenat-data

get-schemas:
	curl -X 'GET' 'https://data.cms.gov/provider-data/api/1/metastore/schemas' -H 'accept: application/json' \
		> data/source/provider-data-schemas.json