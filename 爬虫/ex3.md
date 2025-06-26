# 练习三：处理被多个标签包围的表格文本

本练习演示如何使用 lxml 的 xpath `string(.)` 方法，提取被多个标签包围的单元格文本。

---

```python
# encoding: utf-8
# @Author: xia0ya
# 功能：爬取网页表格数据，处理td内被多个标签包围的文本

import requests
from lxml import etree

# 目标网页地址
url = "https://spiderbuf.cn/web-scraping-practice/lxml-xpath-advanced"
# 自定义请求头，模拟手机浏览器访问
MyHeaders = {'user-agent':"Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Mobile Safari/537.36 Edg/137.0.0.0"}

# 发送带请求头的请求，获取网页源码
html = requests.get(url, headers=MyHeaders).text
# print(html)   # 可选：打印网页源码

# 解析网页内容，构建HTML树
root = etree.HTML(html)
# 提取所有表格行（tr标签）
trs = root.xpath('//tr')

for tr in trs:
    tds = tr.xpath('./td')  # 提取每一行的所有单元格
    s = ''
    for td in tds:
        # 使用string(.)提取被多个标签包围的文本内容
        s = s + str(td.xpath('string(.)')) + '|'
    print(s)  # 打印每行内容
```

---

## 说明
- 该代码通过 `string(.)` 方法，能提取出 td 内所有嵌套标签的文本内容。
- 需要提前安装 `requests` 和 `lxml` 库。
- 可根据实际需求将数据保存到本地文件。 