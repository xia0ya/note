# 练习七：AJAX 动态加载数据的爬取

本练习演示如何爬取通过 AJAX 动态加载的 JSON 数据，并进行解析与格式化输出。

---

```python
# encoding: utf-8
# @Author: xia0ya
# 功能：爬取 AJAX 动态加载的 JSON 数据并格式化输出

import requests
import json

# 目标数据接口（返回 JSON 数据）
url = "https://spiderbuf.cn/web-scraping-practice/iplist"
MyHeaders = {'user-agent':"Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Mobile Safari/537.36 Edg/137.0.0.0"}

data_json = requests.get(url, headers=MyHeaders).text
# print(data_json)   # 可选：打印原始 JSON 数据

# 保存原始数据到本地
f = open("exp02.html", "w", encoding="utf-8")
f.write(data_json)
f.close()

# 解析 JSON 数据
ls = json.loads(data_json)
for item in ls:
    s = '%s|%s|%s|%s|%s|%s|%s|' % (item['ip'],item['mac'],item['manufacturer'],item['name'],item['ports'],item['status'],item['type'],)
    print(s)

# 也可以直接处理本地 JSON 数据
# data_json1 = [{...}, {...}, ...]  # 省略，见原代码

# 定义表头
header = ["序号", "IP", "MAC", "名称", "类型", "制造商", "端口", "状态"]
print("|".join(header) + "|")

# 遍历数据并打印每一行
for index, item in enumerate(ls, start=1):
    row = [
        str(index),
        item["ip"],
        item["mac"],
        item["name"],
        item["type"],
        item["manufacturer"],
        item["ports"],
        item["status"]
    ]
    print("|".join(row) + "|")
```

---

## 说明
- 该代码会请求 AJAX 接口，获取 JSON 数据并格式化输出。
- 需要提前安装 `requests` 和 `json`（Python内置）库。
- 可根据实际需求将数据保存到本地文件或数据库。 