from selenium import webdriver
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
import time
import os

# Path to your ChromeDriver executable
chrome_driver_path = "/opt/homebrew/bin/chromedriver"  # Update this path if necessary

# Configure Selenium options
options = Options()
options.headless = False  # Set to True to run in headless mode
options.add_argument("--start-maximized")  # Open Chrome in maximized mode
options.add_argument(
    "--disable-blink-features=AutomationControlled"
)  # Prevent detection as bot

# Initialize the WebDriver
service = Service(chrome_driver_path)
driver = webdriver.Chrome(service=service, options=options)

try:
    # Load the Zillow research data page
    driver.get("https://www.zillow.com/research/data/")

    # Wait until the page is fully loaded
    WebDriverWait(driver, 10).until(
        EC.presence_of_element_located((By.TAG_NAME, "body"))
    )

    # Scroll to the bottom of the page to ensure all content loads
    driver.execute_script("window.scrollTo(0, document.body.scrollHeight);")
    time.sleep(2)  # Allow time for additional content to load

    # Locate all download links (assuming they're <a> tags with "href")
    download_links = driver.find_elements(By.CSS_SELECTOR, "a[href*='.csv']")

    # Ensure output folder exists
    output_folder = "zillow_data"
    os.makedirs(output_folder, exist_ok=True)

    # Download each link
    for link in download_links:
        file_url = link.get_attribute("href")
        file_name = file_url.split("/")[-1]
        file_path = os.path.join(output_folder, file_name)

        # Use Python's requests library to download the file
        import requests

        response = requests.get(file_url)
        if response.status_code == 200:
            with open(file_path, "wb") as file:
                file.write(response.content)
            print(f"Downloaded: {file_name}")
        else:
            print(f"Failed to download: {file_name}")

finally:
    # Close the WebDriver
    driver.quit()
