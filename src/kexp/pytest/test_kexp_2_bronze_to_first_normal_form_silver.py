#
# Author: Tim Burns
# License: Apache 2.0
#
# A Testing Class to Validate Scraping the KEXP Playlist for the blog
# https://www.owlmountain.net/
# If you like this, donate to KEXP: https://www.kexp.org/donate/

import unittest
import spark_catalog

from pyspark import Row
from pyspark.sql.functions import col, explode, regexp_replace, split


class SparkCatalogTest(unittest.TestCase):
    DELTA_LAKE_FOLDER = "../../../data/spark/kexp"

    catalog = spark_catalog.SparkCatalog(source_name="kexp", lake_location=DELTA_LAKE_FOLDER)

    def test_regexp_replace(self):
        df = self.catalog.sql_context.createDataFrame([Row(col1='z1', col2='[a1, b2, c3]', col3='foo')])
        df.show()
        df.printSchema()

        print("Get rid of [ and ] in col2")
        df.withColumn(
            "col2", regexp_replace(col("col2"), "(^\[)|(\]$)", "")
        ).show()

    def test_col_to_array(self):
        df = self.catalog.sql_context.createDataFrame([Row(col1='z1', col2='[a1, b2, c3]', col3='foo')])

        df.withColumn(
            "col2", regexp_replace(col("col2"), "(^\[)|(\]$)", "")
        ).printSchema()

        print("Turn col2 into an array")
        df.withColumn(
            "col2",
            split(regexp_replace(col("col2"), "(^\[)|(\]$)", ""), ", ")
        ).show()

    def test_transform_to_rows(self):
        df = self.catalog.sql_context.createDataFrame([Row(col1='z1', col2='[a1, b2, c3]', col3='foo')])
        print("Transform col2 to rows")
        df.withColumn(
            "col2",
            explode(split(regexp_replace(col("col2"), "(^\[)|(\]$)", ""), ", "))
        ).show()

    def test_explode_artist(self):
        self.catalog.get_data_frame("bronze", "KEXP_PLAYLIST")
        artist_df = self.catalog.sql("""
select artist_ids id, artist
from KEXP_PLAYLIST 
where artist is not null 
order by artist
        """)
        artist_df = artist_df.withColumn("id", explode(artist_df.id))
        artist_df = self.catalog.add_default_columns(artist_df)
        artist_df.show()

        # self.catalog.append_changed(artist_df, table_schema="silver", table_name="ARTIST", id="id")
