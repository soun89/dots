import os
import requests
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.firefox.service import Service
from selenium.webdriver.firefox.options import Options

# Directory to save downloaded images
save_dir = "high_quality_images"
os.makedirs(save_dir, exist_ok=True)

# Setup Selenium WebDriver for Firefox
firefox_options = Options()
firefox_options.add_argument('--headless')  # Run without UI
service = Service('/home/soun/.local/bin/geckodriver')
driver = webdriver.Firefox(service=service, options=firefox_options)

# Base URL
base_url = "https://sxypix.com/w/c8510edff84e24304e32f497fe1abdf0/"

# Function to download an image
def download_image(img_url, save_path):
    try:
        response = requests.get(img_url, stream=True)
        response.raise_for_status()
        with open(save_path, 'wb') as file:
            for chunk in response.iter_content(chunk_size=8192):
                file.write(chunk)
        print(f"Downloaded: {img_url}")
    except Exception as e:
        print(f"Failed to download {img_url}: {e}")

# Process each page
page_number = 1
while True:
    driver.get(f"{base_url}{page_number}")
    driver.implicitly_wait(5)  # Allow time for dynamic content to load
    print(f"Processing page: {page_number}")

    # Locate all elements with high-quality image data
    high_quality_images = driver.find_elements(By.CSS_SELECTOR, ".gall_pix_el")

    if not high_quality_images:
        print(f"No high-quality images found on page {page_number}. Stopping.")
        break

    for index, img_element in enumerate(high_quality_images):
        try:
            img_url = img_element.get_attribute("data-src")
            if img_url:
                # Prepend HTTPS if needed
                img_url = f"https:{img_url}" if img_url.startswith("//") else img_url
                img_name = os.path.basename(img_url)
                save_path = os.path.join(save_dir, img_name)
                download_image(img_url, save_path)
            else:
                print(f"No valid data-src for image {index + 1} on page {page_number}.")
        except Exception as e:
            print(f"Error processing image {index + 1} on page {page_number}: {e}")
            continue

    # Move to the next page
    page_number += 1

# Clean up
driver.quit()
print("Done!")
