test-args:
	dbt run-operation test_args --args '${shell cat parameters/kexp/radio_show_kexp_pipe_test.json}'

create-pipeline:
	dbt run-operation create_s3_pipe --args '${shell cat parameters/kexp/radio_show_kexp_pipe.json}'

destroy-pipeline:
	dbt run-operation destroy_s3_pipe --args '${shell cat parameters/kexp/radio_show_kexp_pipe.json}'