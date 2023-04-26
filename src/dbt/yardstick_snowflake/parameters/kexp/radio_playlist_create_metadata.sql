select object_construct( lower(column_name), object_construct('DATA_TYPE', data_type, 'IS_NULLABLE', is_nullable))
from information_schema.columns
where table_name = 'IMPORT_KEXP_PLAYLIST'
order by ORDINAL_POSITION;
