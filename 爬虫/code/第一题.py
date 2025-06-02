import requests
import json
import datetime

# === 请填写你的信息 ===
your_name = "张三111"        # 你的姓名
your_student_id = "20250002221"  # 你的学号

# === API 配置 ===
# 网页代码获取分页逻辑，关键在于3075之后
api_template = "https://wap.stockstar.com/dataapi/newslist/3075/{}/0/appendNewsListNoPic/20/0/false"
output_file = f"stock2_{your_name}_{your_student_id}.txt"
all_titles = []
page_num = 0  # 从第 0 页开始

while True:
    print(f"正在抓取第 {page_num} 页...")
    res = requests.get(api_template.format(page_num), timeout=10)
    text = res.text

    # 提取 JSON 数据
    start = text.find('(')
    end = text.rfind(']')
    if start == -1 or end == -1:
        print("未找到有效的 JSON 数据，结束抓取。")
        break

    json_str = text[start + 1:end + 1]
    news_list = json.loads(json_str)

    if not news_list:
        print("没有更多数据了。")
        break

    for item in news_list:
        title = item.get('title')
        if title:
            all_titles.append(title)

    page_num += 1

# === 保存结果 ===
now = datetime.datetime.now().strftime("%Y年%m月%d日")
with open(output_file, 'w', encoding='utf-8') as f:
    for title in all_titles:
        line = f"{title} 由{your_name}于{now}爬取"
        print(line)
        f.write(line + '\n')
print(f"\n共抓取 {len(all_titles)} 条标题，已保存至：{output_file}")
