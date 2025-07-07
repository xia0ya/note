import os
import re
import json
import requests
from bs4 import BeautifulSoup
import urllib3
urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)

BASE_URL = "https://xx.knit.bid"
START_URL = f"{BASE_URL}/sort/hot/"
HEADERS = {
    "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36"
}

def get_sub_links(url):
    resp = requests.get(url, headers=HEADERS)
    soup = BeautifulSoup(resp.text, "html.parser")
    links = []
    for a in soup.select("a.imgbox-link"):
        href = a.get("href")
        title = a.get("title")
        if href and title:
            links.append((BASE_URL + href, title))
    return links

def get_total_pages(soup):
    script = soup.find("script", type="application/ld+json")
    if script:
        data = json.loads(script.string)
        return data.get("pagination", {}).get("totalPages", 1)
    return 1

def get_image_urls_from_page(soup):
    script = soup.find("script", type="application/ld+json")
    if script:
        data = json.loads(script.string)
        return [item["contentUrl"] for item in data.get("itemListElement", []) if "contentUrl" in item]
    return []

def download_image(url, folder, filename):
    resp = requests.get(url, headers=HEADERS, verify=False)
    if resp.status_code == 200:
        with open(os.path.join(folder, filename), "wb") as f:
            f.write(resp.content)

def sanitize_filename(name):
    return re.sub(r'[\\/*?:"<>|]', "_", name)

def main():
    # 创建统一图片文件夹
    images_folder = "images"
    os.makedirs(images_folder, exist_ok=True)
    sub_links = get_sub_links(START_URL)
    for sub_url, title in sub_links:
        print(f"Processing: {title} ({sub_url})")
        safe_title = sanitize_filename(title)
        # Get first page to find total pages
        resp = requests.get(sub_url, headers=HEADERS)
        soup = BeautifulSoup(resp.text, "html.parser")
        total_pages = get_total_pages(soup)
        for page in range(1, total_pages + 1):
            page_url = f"{sub_url}?page={page}" if page > 1 else sub_url
            print(f"  Fetching page {page}/{total_pages}: {page_url}")
            resp = requests.get(page_url, headers=HEADERS)
            soup = BeautifulSoup(resp.text, "html.parser")
            img_urls = get_image_urls_from_page(soup)
            for idx, img_url in enumerate(img_urls, 1):
                ext = os.path.splitext(img_url)[-1]
                filename = f"{safe_title}_{page}_{idx}{ext}"
                print(f"    Downloading: {img_url} -> {filename}")
                download_image(img_url, images_folder, filename)

if __name__ == "__main__":
    main()