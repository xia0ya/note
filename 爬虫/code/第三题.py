import requests
from bs4 import BeautifulSoup

your_name = "张三"
your_student_id = "20250001"
output_filename = f"book1_{your_name}_{your_student_id}.txt"

book_entries = []
total_pages = 50  # 总共50页
for page in range(1, total_pages + 1):
    url = f"http://opac.zufe.edu.cn:8080/opac/openlink.php?location=ALL&title=python&doctype=ALL&lang_code=ALL&match_flag=forward&displaypg=20&showmode=list&orderby=DESC&sort=CATA_DATE&onlylendable=no&count=990&with_ebook=on&page={page}"
    r = requests.get(url, timeout=10)
    r.encoding = 'utf-8'
    soup = BeautifulSoup(r.text, 'html.parser')
    for h3 in soup.find_all('h3'):
        a = h3.find('a')
        if a and a.string:
            book_entries.append(a.string.strip())
    print(f"已抓取第 {page} 页，共 {total_pages} 页")
    continue

with open(output_filename, 'w', encoding='utf-8') as f:
    for entry in book_entries:
        f.write(f"{entry} 由{your_name}(学号：{your_student_id})检索的目录\n")

print(f"共抓取 {len(book_entries)} 条目录，已保存至：{output_filename}")