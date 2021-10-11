select randstr(20, random());

use role ACCOUNTADMIN;

create or replace user KEXP_BI_USER identified by '***';

grant role KEXP_READER_FUNCTION to user KEXP_BI_USER;

ALTER USER KEXP_BI_USER SET DEFAULT_ROLE=KEXP_READER_FUNCTION;