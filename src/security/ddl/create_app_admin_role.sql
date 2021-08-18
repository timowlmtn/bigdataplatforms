create or replace role OWLMTN_ADMIN
   comment = 'This role is the Administrator of the Owlmtn Database';

grant usage
  on database OWLMTN
  to role OWLMTN_ADMIN;

grant all
  on schema OWLMTN.STAGE
  to role OWLMTN_ADMIN;

grant usage
  on warehouse COMPUTE_WH
  to role OWLMTN_ADMIN;