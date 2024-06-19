import os
import requests
from bs4 import BeautifulSoup
from urllib.parse import urljoin

# URL of the data index page
index_url = "https://s3.amazonaws.com/hubway-data/index.html"

# Local folder to save the data
local_folder = "data/hubway-data"

# Create the local folder if it doesn't exist
if not os.path.exists(local_folder):
    os.makedirs(local_folder)


def download_file(url, folder):
    local_filename = os.path.join(folder, url.split("/")[-1])
    with requests.get(url, stream=True) as r:
        r.raise_for_status()
        with open(local_filename, "wb") as f:
            for chunk in r.iter_content(chunk_size=8192):
                f.write(chunk)
    return local_filename


def partition_by_year(local_folder):
    for root, dirs, files in os.walk(local_folder):
        for file in files:
            if file.endswith(".csv"):
                year = file.split("-")[0]
                year_folder = os.path.join(local_folder, year)
                if not os.path.exists(year_folder):
                    os.makedirs(year_folder)
                os.rename(os.path.join(root, file), os.path.join(year_folder, file))


# Get the HTML content of the index page
response = requests.get(index_url)
response.raise_for_status()

print(response.content)

# Parse the HTML content
soup = BeautifulSoup(response.content, "html.parser")

for link in soup.find_all("a"):
    print(f"link: {link}")

# Find all the links to CSV files
csv_links = [
    urljoin(index_url, a["href"])
    for a in soup.find_all("a")
    if a["href"].endswith(".zip")
]

print(csv_links)

# Download each CSV file
for link in csv_links:
    download_file(link, local_folder)

# Partition the downloaded files by year
partition_by_year(local_folder)

print(f"Data downloaded and partitioned by year in the folder: {local_folder}")
