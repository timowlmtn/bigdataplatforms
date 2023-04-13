use role APPADMIN;

create or replace view stage.kexp_show
as select * from stage.EXT_BRONZE_KEXP_SHOW;

grant select on all views in schema stage to role ANALYTICS;