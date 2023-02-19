insert into ANALYTICS.FAVORITE_HOST(DIM_HOST_KEY)
select DIM_HOST_KEY
from WAREHOUSE.DIM_HOST
where NAME = 'Cherryl Waters'

insert into ANALYTICS.FAVORITE_HOST(DIM_HOST_KEY)
with fav_hosts as (select DIM_HOST_KEY, HOST_ID, NAME, URI, IMAGE_URI, THUMBNAIL_URI, IS_ACTIVE
                   from WAREHOUSE.DIM_HOST
                   where NAME in ('Cheryl Waters', 'Evie', 'Gabriel Teodros'))
select DIM_HOST_KEY
from fav_hosts;

select *
from ANALYTICS.FAVORITE_HOST;