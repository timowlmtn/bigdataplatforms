!set variable_substitution=true;

use role &{DATABASE_ADMIN_ROLE};

create stage if not exists STAGE.STAGE_KEXP_PROGRAM
storage_integration = &{STORAGE_INTEGRATION_NAME}
url = 's3://&{EXPORT_BUCKET}/stage/kexp/programs/';

