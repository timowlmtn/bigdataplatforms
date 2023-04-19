test-args:
	dbt run-operation test_args --args '${shell cat parameters/kexp/radio_show_kexp_pipe_test.json}'

create-show-pipe:
	dbt run-operation create_s3_pipe --args '${shell cat parameters/kexp/radio_show_kexp_pipe.json}'

destroy-show-pipe:
	dbt run-operation destroy_s3_pipe --args '${shell cat parameters/kexp/radio_show_kexp_pipe.json}'


create-playlist-pipe:
	dbt run-operation create_s3_pipe --args '${shell cat parameters/kexp/radio_playlist_kexp_pipe.json}'

destroy-playlist-pipe:
	dbt run-operation destroy_s3_pipe --args '${shell cat parameters/kexp/radio_playlist_kexp_pipe.json}'