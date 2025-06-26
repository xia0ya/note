# 练习八：HTTP POST 请求的数据抓取

本练习演示如何通过 HTTP POST 请求方式抓取网页数据，并解析表格内容。

---

```python
# encoding: utf-8
# @Author: xia0ya
# 功能：通过 HTTP POST 请求抓取网页表格数据

import requests
from lxml import etree

# 目标URL
url = "https://spiderbuf.cn/web-scraping-practice/scraper-via-http-post"

# 自定义请求头
MyHeaders = {
    'user-agent': "Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Mobile Safari/537.36 Edg/137.0.0.0"
}

# POST请求的表单数据
data = {
    "level": "8"  # 根据页面中的隐藏表单字段设置
}

# 发送POST请求
response = requests.post(url, headers=MyHeaders, data=data)

# 检查响应状态
if response.status_code == 200:
    html = response.text
    # print(html)  # 可选：打印获取到的网页源码

    # 解析HTML内容
    root = etree.HTML(html)
    trs = root.xpath('//tr')

    # 遍历表格行并提取数据
    for tr in trs:
        tds = tr.xpath('./td/text()')  # 获取每个单元格的文本
        s = '|'.join(tds)  # 将单元格内容用'|'拼接
        print(s)  # 打印每行数据

    # 保存文件（可选）
    # with open("data01.txt", "w", encoding='utf-8') as f:
    #     for tr in trs:
    #         tds = tr.xpath('./td/text()')
    #         s = '|'.join(tds)
    #         if s:
    #             f.write(s + '\n')
else:
    print(f"请求失败，状态码：{response.status_code}")
```

---

## 说明
- 该代码通过 POST 请求方式抓取网页表格数据。
- 需要提前安装 `requests` 和 `lxml` 库。
- 可根据实际需求将数据保存到本地文件。 