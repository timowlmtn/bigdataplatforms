{{
    config(
        materialized='table',
        tags=['zillow']
    )
}}

SELECT
    "RegionID",
    "SizeRank",
    "RegionName",
    "RegionType",
    "StateName",
    date_column AS Date,
    zordi_value AS Zordi_Value
FROM (
    SELECT
        "RegionID",
        "SizeRank",
        "RegionName",
        "RegionType",
        "StateName",
        UNNEST(ARRAY[
            '2020_06_30', '2020_07_31', '2020_08_31', '2020_09_30', '2020_10_31',
            '2020_11_30', '2020_12_31', '2021_01_31', '2021_02_28', '2021_03_31',
            '2021_04_30', '2021_05_31', '2021_06_30', '2021_07_31', '2021_08_31',
            '2021_09_30', '2021_10_31', '2021_11_30', '2021_12_31', '2022_01_31',
            '2022_02_28', '2022_03_31', '2022_04_30', '2022_05_31', '2022_06_30',
            '2022_07_31', '2022_08_31', '2022_09_30', '2022_10_31', '2022_11_30',
            '2022_12_31', '2023_01_31', '2023_02_28', '2023_03_31', '2023_04_30',
            '2023_05_31', '2023_06_30', '2023_07_31', '2023_08_31', '2023_09_30',
            '2023_10_31', '2023_11_30', '2023_12_31', '2024_01_31', '2024_02_29',
            '2024_03_31', '2024_04_30', '2024_05_31', '2024_06_30', '2024_07_31',
            '2024_08_31', '2024_09_30', '2024_10_31', '2024_11_30'
        ]) AS date_column,
        UNNEST(ARRAY[
            "2020_06_30", "2020_07_31", "2020_08_31", "2020_09_30", "2020_10_31",
            "2020_11_30", "2020_12_31", "2021_01_31", "2021_02_28", "2021_03_31",
            "2021_04_30", "2021_05_31", "2021_06_30", "2021_07_31", "2021_08_31",
            "2021_09_30", "2021_10_31", "2021_11_30", "2021_12_31", "2022_01_31",
            "2022_02_28", "2022_03_31", "2022_04_30", "2022_05_31", "2022_06_30",
            "2022_07_31", "2022_08_31", "2022_09_30", "2022_10_31", "2022_11_30",
            "2022_12_31", "2023_01_31", "2023_02_28", "2023_03_31", "2023_04_30",
            "2023_05_31", "2023_06_30", "2023_07_31", "2023_08_31", "2023_09_30",
            "2023_10_31", "2023_11_30", "2023_12_31", "2024_01_31", "2024_02_29",
            "2024_03_31", "2024_04_30", "2024_05_31", "2024_06_30", "2024_07_31",
            "2024_08_31", "2024_09_30", "2024_10_31", "2024_11_30"
        ]) AS zordi_value
    FROM "Metro_zordi_uc_sfrcondomfr_month"
) unpivoted
