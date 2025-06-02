## 题目要求

实验3：抓取学校图书馆图书检索目录（3分）
从以下网址进入并检索与自己专业相关的图书：
http://opac.zufe.edu.cn:8080/opac/openlink.php?s2_type=title&s2_text=python&search_bar=new&title=python&doctype=ALL&with_ebook=on&match_flag=forward&showmode=list&location=ALL 
编写程序，爬取检索得到的图书目录，输出到屏幕并将目录保存到文本文件book_张三_学号.txt中（在每个图书检索目录后自动添加上自己的姓名和学号，如：由张三(学号：20200001)检索的目录）

## 代码

```{python}
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
```
