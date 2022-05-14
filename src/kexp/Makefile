##
# This Makefile gets the copied playlist data from S3 and writes it to a file
# called data/export/import_kexp_playlist.csv with the CSV containing the playlist.
#
# It is used to upload to Tableau
#
# Author: Tim Burns		Date: 10/04/2021
default: get-export

clean:
	rm -f  data/export/import_kexp_playlist.csv data/export/import_kexp_playlist_0_*.csv

get-export-s3:
	aws s3 sync s3://owlmtn-stage-data/stage/kexp/export/ data/export

translate-comma:
	sed 's/\\,/,/g' data/export/import_kexp_playlist_header_0_0_0.csv > data/export/import_header.csv

concatenat-data:
	cat data/export/import_header.csv data/export/import_kexp_playlist_0_*.csv > data/export/import_kexp_playlist.csv

compress-data:
	gzip -f data/export/import_kexp_playlist.csv

pipeline:
	snowsql -f snowflake/sql/copy_stage_import_playlist.sql
	snowsql -f snowflake/sql/copy_stage_import_show.sql
	snowsql -f snowflake/sql/extract_playlist_show.sql

get-export: clean pipeline get-export-s3 translate-comma concatenat-data compress-data

install:
	pip3 install -r requirements.txt
