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

        artist_df = self.catalog.explode_array(artist_df, "id")

        artist_df.show()

        self.assertEqual(['id', 'artist'], artist_df.columns)
        self.assertEqual(['df.id', 'df.artist'],
                         list(map(lambda x: 'df.' + x, artist_df.columns)))
        self.assertEqual("df.id, df.artist",
                         ", ".join(list(map(lambda x: 'df.' + x, artist_df.columns))))

        print(self.catalog.append_changed(data_frame=artist_df,
                                          table_schema="silver",
                                          table_name="ARTIST",
                                          identifier_columns=["id"]))

    def test_identifier_logic(self):
        identifier_columns = ["genre", "program_id"]
        self.assertEqual(["df1.genre != df2.genre", "df1.program_id != df2.program_id"],
                         list(map(lambda x: f'df1.{x} != df2.{x}', identifier_columns)))
        identifier_values = list(map(lambda x: f'df1.{x} != df2.{x}', identifier_columns))
        self.assertEqual("df1.genre != df2.genre and df1.program_id != df2.program_id",
                         " and ".join(identifier_values))

    def test_explode_program_tags(self):
        self.catalog.get_data_frame("bronze", "KEXP_PROGRAM")
        genre_df = self.catalog.sql("""
select tags genre, id program_id
from KEXP_PROGRAM 
where is_active = true
                """)

        genre_df = self.catalog.explode_string(genre_df, "genre")
        genre_df.show()

        print(self.catalog.append_changed(data_frame=genre_df,
                                          table_schema="silver",
                                          table_name="PROGRAM_GENRE",
                                          identifier_columns=["genre", "program_id"]))
