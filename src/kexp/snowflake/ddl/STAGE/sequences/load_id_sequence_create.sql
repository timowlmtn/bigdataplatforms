!set variable_substitution=true;
use role &{DATABASE_ADMIN_ROLE};
CREATE SEQUENCE if not exists STAGE.LOAD_ID_SEQUENCE
    START = 1
    INCREMENT = 1
;
