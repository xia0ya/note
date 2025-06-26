# 练习五：网页图片的爬取及本地保存

本练习演示如何批量爬取网页中的图片，并将其保存到本地。

---

```python
# encoding: utf-8
# @Author: xia0ya
# 功能：爬取网页中的所有图片并保存到本地

import requests
from lxml import etree
import re

# 目标网页地址
url = "https://spiderbuf.cn/web-scraping-practice/scraping-images-from-web"
MyHeaders = {'user-agent':"Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Mobile Safari/537.36 Edg/137.0.0.0"}

# 获取网页源码
html = requests.get(url, headers=MyHeaders).text
# print(html)   # 可选：打印网页源码

# 解析网页内容，提取所有图片的src属性
root = etree.HTML(html)
imgs = root.xpath('//img/@src')
print(imgs)  # 打印所有图片链接
for item in imgs:
    # 拼接完整图片URL并下载图片内容
    img_data = requests.get('https://spiderbuf.cn' + item , headers=MyHeaders).content
    # 以图片路径命名文件并保存
    img = open(str(item).replace('/', ''),'wb')
    img.write(img_data)
    img.close()
```

---

## 说明
- 该代码会下载网页中的所有图片，并以图片路径命名保存到本地。
- 需要提前安装 `requests` 和 `lxml` 库。
- 可根据实际需求修改图片保存路径和命名方式。 