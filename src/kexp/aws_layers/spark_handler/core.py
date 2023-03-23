# ------------------------------------------------
# Spark Core Handler Class
#
#  This program wraps common Spark Functionality.
#
# ------------------------------------------------
# License: Apache 2.0
# ------------------------------------------------
# Author: Tim Burns
# Copyright: 2023, Big Data Platforms
# Credits: [KEXP and developers]
# Version: 0.0.1
# Maintainer: Tim Burns
# Email: timburnsowlmtn@gmail.com
# Status: Demo Code
# ------------------------------------------------

class SparkCore:
    raw_data_folder = None

    def __init__(self, raw_data_folder):
        self.raw_data_folder = raw_data_folder

    def process_bronze(self):
        return {"raw_data_folder": self.raw_data_folder}
