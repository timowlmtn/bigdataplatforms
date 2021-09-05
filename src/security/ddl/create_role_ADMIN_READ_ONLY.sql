/**
  The Admin Read Only role is a functional role to read all the tables and views  in the ADMIN schema.
 */
create or replace role ADMIN_READ_ONLY;

-- Grant usage on the database, schema, and warehouse
grant usage on database OWLMTN to role ADMIN_READ_ONLY;
grant usage on schema ADMIN to role ADMIN_READ_ONLY;
grant usage on warehouse COMPUTE_WH to role ADMIN_READ_ONLY;

-- Grant read access to all tables and all views in the ADMIN schema
grant select on all tables in schema ADMIN to role ADMIN_READ_ONLY;
grant select on future tables in schema ADMIN to role ADMIN_READ_ONLY;
grant select on all views in schema ADMIN to role ADMIN_READ_ONLY;
grant select on future views in schema ADMIN to role ADMIN_READ_ONLY;

-- Assign the role to a functional role
grant role ADMIN_READ_ONLY to role USER_ACCESS_VIEWER;

