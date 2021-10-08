select randstr(20, random());

use role ACCOUNTADMIN;

create or replace user KEXP_BI_USER identified by 'XJERqIoCaeCEYP61MUlq';

grant role KEXP_READER_FUNCTION to user KEXP_BI_USER;