select *
from s3('s3://owlmtn-datalake-prod/stage/kexp/playlists/20231225110357/playlist20231225110357.json',
        'JSONEachRow')