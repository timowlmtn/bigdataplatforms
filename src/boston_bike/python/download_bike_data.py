import os
import requests
from bs4 import BeautifulSoup

# Path to the local HTML file
local_html_file = "data/out/rendered_page.html"

# Folder to save the downloaded ZIP files
download_folder = "data/hubway-data"

# Create the download folder if it doesn't exist
os.makedirs(download_folder, exist_ok=True)

def download_file(url, folder):
    local_filename = os.path.join(folder, url.split('/')[-1])
    with requests.get(url, stream=True) as r:
        r.raise_for_status()
        with open(local_filename, 'wb') as f:
            for chunk in r.iter_content(chunk_size=8192):
                f.write(chunk)
    return local_filename

# Read the local HTML file
with open(local_html_file, 'r') as file:
    html_content = file.read()

# Parse the HTML content with BeautifulSoup
soup = BeautifulSoup(html_content, 'html.parser')

# Find all the links to ZIP files
zip_links = [a['href'] for a in soup.find_all('a') if a['href'].endswith('.zip')]

# Download each ZIP file
for link in zip_links:
    download_file(link, download_folder)

print(f"All ZIP files have been downloaded to the folder: {download_folder}")
