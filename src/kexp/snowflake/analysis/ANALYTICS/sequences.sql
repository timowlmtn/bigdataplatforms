select *
from WAREHOUSE.DIM_HOST
    where name like 'John%';


-- Here are my favorite DJs
merge into ANALYTICS.FAVORITE_HOST tar
    using
        (select dim_host_key
         from warehouse.dim_host
         where NAME in ('Cheryl Waters', 'Evie', 'Gabriel Teodros'--, 'John Richards'
                       )
    ) as src
    on tar.dim_host_key = src.dim_host_key
    when not matched then
insert (dim_host_key)
values (
    src.DIM_HOST_KEY
    );

select fav.FAVORITE_RANK, host.NAME
from ANALYTICS.FAVORITE_HOST fav
inner join WAREHOUSE.DIM_HOST host on fav.DIM_HOST_KEY = host.DIM_HOST_KEY
order by fav.DW_CREATE_DATE;

