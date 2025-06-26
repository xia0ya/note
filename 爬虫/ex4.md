# 练习四：分页爬取与翻页处理

本练习演示如何自动识别网页的总页数，并循环爬取所有分页内容。

---

```python
# encoding: utf-8
# @Author: xia0ya
# 功能：自动识别总页数，循环爬取所有分页表格数据

import requests
from lxml import etree
import re

# 分页网页的基础URL，%d为页码占位符
base_url = "https://spiderbuf.cn/web-scraping-practice/web-pagination-scraper?pageno=%d"
MyHeaders = {'user-agent':"Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Mobile Safari/537.36 Edg/137.0.0.0"}

# 获取第一页内容，解析出总页数
html = requests.get(base_url % 1, headers=MyHeaders).text
root = etree.HTML(html)
lis = root.xpath('//ul[@class="pagination"]/li')  # 定位分页信息
page_text = lis[0].xpath('string(.)')
ls = re.findall(r'\d+', str(page_text))  # 正则提取数字
max_no = int(ls[0])  # 总页数

for i in range(1, max_no+1):
    print(i)  # 当前页码
    url = base_url % i
    print(url)  # 当前页URL
    html = requests.get(url, headers=MyHeaders).text
    root = etree.HTML(html)
    trs = root.xpath('//tr')
    for tr in trs:
        tds = tr.xpath('./td')
        s = ''
        for td in tds:
            # 提取所有嵌套标签文本
            s = s + str(td.xpath('string(.)')) + '|'
        print(s)
```

---

## 说明
- 该代码会自动获取总页数，循环爬取每一页的表格内容。
- 需要提前安装 `requests`、`lxml` 和 `re` 库（re为Python内置库）。
- 可根据实际需求将数据保存到本地文件。 