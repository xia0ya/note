# 练习一：使用 requests 和 lxml 爬取表格数据

本练习演示如何使用 Python 的 requests 和 lxml 库，爬取网页表格数据并保存到本地文件。

---

```python
# encoding: utf-8
# @Author: xia0ya
# 功能：爬取指定网页的表格数据，并保存为本地txt文件

import requests
from lxml import etree

# 目标网页地址
url = "https://spiderbuf.cn/web-scraping-practice/requests-lxml-for-scraping-beginner"

# 获取网页源码
html = requests.get(url).text
# print(html)   # 可选：打印网页源码

# 解析网页内容，构建HTML树
root = etree.HTML(html)
# 提取所有表格行（tr标签）
trs = root.xpath('//tr')

# 打开本地文件用于写入数据
f = open("data01.txt", "w", encoding='utf-8')

for tr in trs:
    tds = tr.xpath('./td')  # 提取每一行的所有单元格
    s = ''
    for td in tds:
        # 获取单元格文本内容
        s = s + str(td.text) + '|'
    print(s)  # 打印每行内容
    if s != 0:
        f.write(s + '\n')  # 写入文件
f.close()  # 关闭文件
```

---

## 说明
- 该代码会访问目标网页，解析表格内容，并将每行数据以“|”分隔写入 `data01.txt` 文件。
- 需要提前安装 `requests` 和 `lxml` 库。
- 可根据实际需求修改保存文件名。
