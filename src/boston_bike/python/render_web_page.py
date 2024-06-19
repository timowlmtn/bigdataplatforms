from selenium import webdriver
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
import time

# Path to your ChromeDriver executable
chrome_driver_path = "/opt/homebrew/bin/chromedriver"  # Update this path if necessary

# Configure Selenium to use headless mode
options = Options()
options.headless = False  # Set to True if you want to run in headless mode
options.add_argument("--start-maximized")  # Open Chrome in maximized mode

# Initialize the WebDriver
service = Service(chrome_driver_path)
driver = webdriver.Chrome(service=service, options=options)

try:
    # Load the web page
    driver.get("https://s3.amazonaws.com/hubway-data/index.html")

    # Wait until the page is fully loaded
    WebDriverWait(driver, 10).until(
        EC.presence_of_element_located((By.TAG_NAME, "body"))
    )

    # You can interact with the page here if needed
    # For example, scroll to the bottom to ensure all content is loaded
    driver.execute_script("window.scrollTo(0, document.body.scrollHeight);")
    time.sleep(2)  # Wait for the page to load additional content

    # Take a screenshot of the entire page
    screenshot_path = "screenshot.png"
    driver.save_screenshot(screenshot_path)
    print(f"Screenshot saved to {screenshot_path}")

    # Extract the rendered HTML
    html = driver.page_source
    with open("data/out/rendered_page.html", "w") as file:
        file.write(html)
    print("Rendered HTML saved to rendered_page.html")

finally:
    # Close the WebDriver
    driver.quit()
