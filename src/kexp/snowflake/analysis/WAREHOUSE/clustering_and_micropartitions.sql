select count(*),
       max(DW_UPDATE_DATE) LAST_UPDATED
from WAREHOUSE.DIM_KEXP_SHOW;

select count(*),
       max(DW_UPDATE_DATE) playlist_last_updated
from WAREHOUSE.FACT_KEXP_PLAYLIST plays;

use schema WAREHOUSE;


desc table WAREHOUSE.FACT_KEXP_PLAYLIST;

SELECT TABLE_CATALOG, TABLE_SCHEMA, TABLE_NAME, CLUSTERING_KEY
FROM INFORMATION_SCHEMA.TABLES
WHERE CLUSTERING_KEY IS NOT NULL;

alter table warehouse.FACT_KEXP_PLAYLIST
    cluster by (SHOW_ID);

select system$clustering_depth('WAREHOUSE.FACT_KEXP_PLAYLIST');

select SYSTEM$CLUSTERING_INFORMATION('WAREHOUSE.FACT_KEXP_PLAYLIST');

select *
from table (OWLMTN.information_schema.automatic_clustering_history());


with sys_cluster_info as
         (
             SELECT system$clustering_information('WAREHOUSE.FACT_KEXP_PLAYLIST')
         )
select PARSE_JSON($1):cluster_by_keys                as cluster_by_keys,
       PARSE_JSON($1):total_partition_count          as total_partition_count,
       PARSE_JSON($1):total_constant_partition_count as total_constant_partition_count,
       PARSE_JSON($1):average_overlaps               as average_overlaps,
       PARSE_JSON($1):average_depth                  as average_depth,
       PARSE_JSON($1):partition_depth_histogram      as partition_depth_histogram
from sys_cluster_info;