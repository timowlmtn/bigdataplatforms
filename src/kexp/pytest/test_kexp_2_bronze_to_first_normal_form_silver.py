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

        print(self.catalog.append_incremental(data_frame=artist_df,
                                              source_schema="bronze",
                                              source_temp_view_name="KEXP_PLAYLIST",
                                              table_schema="silver",
                                              table_name="ARTIST"))

    def test_identifier_logic(self):
        identifier_columns = ["genre", "program_id"]
        self.assertEqual(["df1.genre != df2.genre", "df1.program_id != df2.program_id"],
                         list(map(lambda x: f'df1.{x} != df2.{x}', identifier_columns)))
        identifier_values = list(map(lambda x: f'df1.{x} != df2.{x}', identifier_columns))
        self.assertEqual("df1.genre != df2.genre and df1.program_id != df2.program_id",
                         " and ".join(identifier_values))

    def test_explode_program_tags(self):
        kexp_program = self.catalog.get_data_frame("bronze", "KEXP_PROGRAM")

        kexp_program.agg({"bronze_modified_timestamp": "max"}).show()

        genre_df = self.catalog.sql(
            "select tags genre, id program_id from KEXP_PROGRAM where is_active = true")

        genre_df = self.catalog.explode_string(genre_df, "genre")
        genre_df.show()

        print(self.catalog.append_incremental(data_frame=genre_df,
                                              source_schema="bronze",
                                              source_temp_view_name="KEXP_PROGRAM",
                                              table_schema="silver",
                                              table_name="PROGRAM_GENRE"))

    def test_append_show(self):
        show_bronze = self.catalog.get_data_frame("bronze", "KEXP_SHOW")
        show_bronze.agg({"id": "max"}).show()
        show_silver = self.catalog.get_data_frame("silver", "SHOW")
        show_silver.agg({"id": "max"}).show()

        playlist_bronze = self.catalog.get_data_frame("bronze", "KEXP_PLAYLIST")
        playlist_bronze.agg({"id": "max"}).show()
        playlist_silver = self.catalog.get_data_frame("silver", "PLAYLIST")
        playlist_silver.agg({"id": "max"}).show()

    def test_subquery(self):
        kexp_program = self.catalog.get_data_frame("bronze", "KEXP_PROGRAM")
        kexp_program = kexp_program.alias('df1')
        kexp_program.agg({"bronze_modified_timestamp": "max"}).show()
        changes = self.catalog.sql('select max(bronze_modified_timestamp) from KEXP_PROGRAM')
        changes = self.catalog.add_default_columns("bronze", "kexp", changes)
        changes.show()

        self.catalog.get_data_frame("silver", "PROGRAM_GENRE")
        changes = self.catalog.sql('select * from PROGRAM_GENRE')
        changes.show()

        changes = self.catalog.sql(f"select * from KEXP_PROGRAM"
                                   f" where bronze_modified_timestamp > "
                                   f"   (select max(silver_modified_timestamp) from PROGRAM_GENRE)")

        changes.show()

    def test_append_playlist(self):
        self.catalog.get_data_frame("bronze", "KEXP_PLAYLIST")
        kexp_playlist = self.catalog.sql(
            "select distinct artist_ids id, artist from KEXP_PLAYLIST where artist is not null order by artist")
        kexp_playlist.printSchema()

        self.catalog.get_data_frame("silver", "ARTIST")
        artist = self.catalog.sql("select * from ARTIST")
        artist.printSchema()
