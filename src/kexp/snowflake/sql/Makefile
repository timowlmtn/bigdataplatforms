get-export-playlist:
	aws s3 sync s3://owlmtn-stage-data/stage/kexp/export/ data/export
	sed 's/\\,/,/g' data/export/import_kexp_playlist_header_0_0_0.csv > data/export/import_header.csv
	cat data/export/import_header.csv data/export/import_kexp_playlist_0_*.csv > data/export/import_kexp_playlist.csv

get-export: get-export-show get-export-playlist