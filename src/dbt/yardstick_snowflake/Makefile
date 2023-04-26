default: sync-kexp-s3

sync-kexp-s3:
	python3 ../../../kexp/python/sync_kexp_s3.py

test-args:
	dbt run-operation test_args --args '${shell cat parameters/kexp/radio_show_kexp_pipe_test.json}'

create-show:
	dbt run-operation create_s3_pipe --args '${shell cat parameters/kexp/radio_show_kexp_pipe.json}'

destroy-show:
	dbt run-operation destroy_s3_pipe --args '${shell cat parameters/kexp/radio_show_kexp_pipe.json}'


create-playlist:
	dbt run-operation create_s3_pipe --args '${shell cat parameters/kexp/radio_playlist_kexp_pipe.json}'

destroy-playlist:
	dbt run-operation destroy_s3_pipe --args '${shell cat parameters/kexp/radio_playlist_kexp_pipe.json}'

install:
	pip install -r ../requirements.txt