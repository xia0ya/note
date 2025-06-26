# 练习六：带 iframe 的页面源码分析与数据爬取

本练习演示如何分析和爬取包含 iframe 的网页数据，注意有些网页的真实数据地址并不是浏览器地址栏显示的地址。

---

```python
# encoding: utf-8
# @Author: xia0ya
# 功能：分析并爬取带 iframe 的网页表格数据

import requests
from lxml import etree
import re

# 目标网页地址（注意：实际数据可能在 iframe 内部）
url = "https://spiderbuf.cn/web-scraping-practice/inner"
MyHeaders = {'user-agent':"Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Mobile Safari/537.36 Edg/137.0.0.0"}

# 获取网页源码
html = requests.get(url, headers=MyHeaders).text
# print(html)   # 可选：打印网页源码

# 解析网页内容，提取表格数据
root = etree.HTML(html)
trs = root.xpath('//tr')

for tr in trs:
    tds = tr.xpath('./td')
    s = ''
    for td in tds:
        # 提取所有嵌套标签文本
        s = s + str(td.xpath('string(.)')) + '|'
    print(s)  # 打印每行内容
```

---

## 说明
- 该代码用于爬取带 iframe 的网页表格数据。
- 需要提前安装 `requests` 和 `lxml` 库。
- 实际开发中，需注意 iframe 内部数据的真实请求地址。 