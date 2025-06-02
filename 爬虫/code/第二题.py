import requests
from bs4 import BeautifulSoup
import datetime

your_name = "张三"       # 修改为你的名字
your_student_id = "20250001"  # 修改为你的学号
output_filename = f"浙财大_{your_name}_{your_student_id}.txt"

base_url = 'https://www.zufe.edu.cn/index/xydt.htm'
page_url = 'https://www.zufe.edu.cn/index/xydt/{}.htm'  # 分页逻辑
all_titles = []

# 抓取
total_pages = 222  # 总共222页
for page in range(1, 223):
    url = base_url if page == 1 else page_url.format(page)
    r = requests.get(url)
    r.encoding = 'utf-8'
    soup = BeautifulSoup(r.text, 'html.parser')
    divs = soup.find_all('h4', class_='l1 h4s1')
    for div in divs:
        if div.string:
            all_titles.append(div.string.strip())
    print(f"已抓取第 {page} 页，共 {total_pages} 页")

# 写入文件
date_str = datetime.datetime.now().strftime("%Y年%m月%d日")
with open(output_filename, 'w', encoding='utf-8') as f:
    for title in all_titles:
        f.write(f"{title} 由{your_name}于{date_str}爬取\n")

print(f"共抓取 {len(all_titles)} 条标题，已保存到文件: {output_filename}")
