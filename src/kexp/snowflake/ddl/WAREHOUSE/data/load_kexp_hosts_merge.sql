merge into WAREHOUSE.DIM_HOST tar
    using (with input as (select parse_json(
                                         '{
    "count": 50,
    "next": null,
    "previous": "https://api.kexp.org/v2/hosts/?is_active=true&limit=20&offset=20",
    "results": [
        {
            "id": 91,
            "uri": "https://api.kexp.org/v2/hosts/91/",
            "name": "Rachel Stevens",
            "image_uri": "https://www.kexp.org/filer/canonical/1657810661/27325/",
            "thumbnail_uri": "",
            "is_active": true
        },
        {
            "id": 37,
            "uri": "https://api.kexp.org/v2/hosts/37/",
            "name": "Reeves",
            "image_uri": "https://www.kexp.org/filer/canonical/1532029736/11081/",
            "thumbnail_uri": "",
            "is_active": true
        },
        {
            "id": 83,
            "uri": "https://api.kexp.org/v2/hosts/83/",
            "name": "Reverend Dollars",
            "image_uri": "https://www.kexp.org/filer/canonical/1595547859/23073/",
            "thumbnail_uri": "",
            "is_active": true
        },
        {
            "id": 38,
            "uri": "https://api.kexp.org/v2/hosts/38/",
            "name": "Sean",
            "image_uri": "https://www.kexp.org/filer/canonical/1529966588/10607/",
            "thumbnail_uri": "",
            "is_active": true
        },
        {
            "id": 41,
            "uri": "https://api.kexp.org/v2/hosts/41/",
            "name": "Stevie Zoom",
            "image_uri": "https://www.kexp.org/filer/canonical/1529970438/10636/",
            "thumbnail_uri": "",
            "is_active": true
        },
        {
            "id": 86,
            "uri": "https://api.kexp.org/v2/hosts/86/",
            "name": "Supreme La Rock",
            "image_uri": "https://www.kexp.org/filer/canonical/1602268539/23758/",
            "thumbnail_uri": "",
            "is_active": true
        },
        {
            "id": 42,
            "uri": "https://api.kexp.org/v2/hosts/42/",
            "name": "Tanner Ellison",
            "image_uri": "https://www.kexp.org/filer/canonical/1529971085/10641/",
            "thumbnail_uri": "",
            "is_active": true
        },
        {
            "id": 43,
            "uri": "https://api.kexp.org/v2/hosts/43/",
            "name": "Troy Nelson",
            "image_uri": "https://www.kexp.org/filer/canonical/1583367959/22030/",
            "thumbnail_uri": "",
            "is_active": true
        },
        {
            "id": 87,
            "uri": "https://api.kexp.org/v2/hosts/87/",
            "name": "Vitamin D",
            "image_uri": "https://www.kexp.org/filer/canonical/1605283503/23997/",
            "thumbnail_uri": "",
            "is_active": true
        },
        {
            "id": 54,
            "uri": "https://api.kexp.org/v2/hosts/54/",
            "name": "Youth DJ",
            "image_uri": "https://www.kexp.org/media/filer_public/3d/9c/3d9cb977-95f1-4a43-a239-237569fbda0e/90teen_thumbnail.jpg",
            "thumbnail_uri": "",
            "is_active": true
        }
    ]
}'
                                     ) SRC)
           select value:id::string            host_id
                , value:name::string          name
                , value:uri::string           uri
                , value:image_uri::string     image_uri
                , value:thumbnail_uri::string thumbnail_uri
                , value:is_active             is_active
--     , value
           from input src, LATERAL FLATTEN(INPUT => SRC:results))
        as src on src.host_id = tar.HOST_ID
    when matched then update set
        tar.NAME = src.name,
        tar.URI = src.uri,
        tar.IMAGE_URI = src.image_uri,
        tar.THUMBNAIL_URI = src.thumbnail_uri,
        tar.IS_ACTIVE = src.is_active
    when not matched then insert (HOST_ID,
                                  NAME,
                                  URI,
                                  IMAGE_URI,
                                  THUMBNAIL_URI,
                                  IS_ACTIVE)
        values (src.HOST_ID,
                src.NAME,
                src.URI,
                src.IMAGE_URI,
                src.THUMBNAIL_URI,
                src.IS_ACTIVE)
;