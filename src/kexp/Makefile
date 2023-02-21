##
# This Makefile gets the copied playlist data from S3 and writes it to a file
# called data/export/import_kexp_playlist.csv with the CSV containing the playlist.
#
# It is used to upload to Tableau
#
# Author: Tim Burns		Date: 10/04/2021
#
# Revised 9/25/022 - Refactor to support STREAMS article on Medium.
#
default: get-export

clean:
	rm -f  data/export/import_kexp_playlist.csv data/export/import_kexp_playlist_0_*.csv

get-export-s3:
	aws s3 sync s3://owlmtn-stage-data/stage/kexp/export/data/export

translate-comma:
	sed 's/\\,/,/g' data/export/import_kexp_playlist_header_0_0_0.csv > data/export/import_header.csv

concatenat-data:
	cat data/export/import_header.csv data/export/import_kexp_playlist_0_*.csv > data/export/import_kexp_playlist.csv

compress-data:
	gzip -f data/export/import_kexp_playlist.csv

sync-kexp-api:
	python3 python/sync_kexp_s3.py

pipeline-import-playlist:
	snowsql -f snowflake/pipeline/0_copy_stage_import_playlist.sql

pipeline-import-show:
	snowsql -f snowflake/pipeline/0_copy_stage_import_show.sql

pipeline-merge-playlist:
	snowsql -f snowflake/pipeline/3_merge_warehouse_playlist.sql

pipeline-merge-show:
	snowsql -f snowflake/pipeline/3_merge_warehouse_show.sql

pipeline: sync-kexp-api pipeline-import-playlist pipeline-import-show pipeline-merge-playlist pipeline-merge-show

pipeline-extract-data:
	snowsql -f snowflake/pipeline/2_extract_playlist_show_data.sql

pipeline-extract-header:
	snowsql -f snowflake/pipeline/2_extract_playlist_show_header.sql

export_data: pipeline pipeline-extract-data pipeline-extract-header

create-ddl-stage-kexp:
	make -f snowflake/Makefile create-kexp-program-stage

create-ddl-import-kexp:
	make -f snowflake/Makefile create-kexp-program-import

pipeline-kexp-import:
	snowsql -f snowflake/pipeline/0_copy_stage_import_program.sql

pipeline-kexp-program: pipeline-kexp-import
	snowsql -f snowflake/pipeline/2_merge_warehouse_program.sql

get-export: clean export_data get-export-s3 translate-comma concatenat-data # compress-data

install:
	pip3 install -r requirements.txt
