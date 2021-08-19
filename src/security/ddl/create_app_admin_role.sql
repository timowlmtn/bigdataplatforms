create or replace role OWLMTN_ADMIN
   comment = 'This role is the Administrator of the Owlmtn Database';

create schema ADMIN WITH MANAGED ACCESS
    comment = 'Ensure only the Schema Owner can manage grants on the objects in the ADMIN schema';

grant usage
  on database OWLMTN
  to role OWLMTN_ADMIN;

grant ownership on
  schema OWLMTN.ADMIN
  to role ACCOUNTADMIN;

grant all privileges on table OWLMTN.ADMIN.SNOWFLAKE_USERS
to role OWLMTN_ADMIN;

grant usage
  on warehouse COMPUTE_WH
  to role OWLMTN_ADMIN;