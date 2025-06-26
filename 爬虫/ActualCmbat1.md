 # 练习三十：湿热一瞬间图片爬取

 湿热一瞬间图片爬取

---

## 模板

```python
# encoding: utf-8
# @Author: xia0ya

import os
import time
import requests
from bs4 import BeautifulSoup
from urllib.parse import urljoin, urlparse, parse_qs
import random
import logging
import re

# 设置日志
logging.basicConfig(level=logging.DEBUG, format='%(asctime)s - %(levelname)s - %(message)s')

# 设置目标网站的URL
base_url = 'https://www.shireyishunjian.com/'
main_url = 'https://www.shireyishunjian.com/main/'
forum_url = 'https://www.shireyishunjian.com/main/forum.php?mod=forumdisplay&fid=279'
login_url = 'https://www.shireyishunjian.com/main/member.php?mod=logging&action=login&loginsubmit=yes&infloat=yes&lssubmit=yes'

# 设置图片保存目录
save_dir = 'downloaded_images'
os.makedirs(save_dir, exist_ok=True)

# 设置请求头
headers = {
    'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/121.0.0.0 Safari/537.36',
    'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7',
    'Accept-Language': 'zh-CN,zh;q=0.9,en;q=0.8',
    'Accept-Encoding': 'gzip, deflate',
    'Connection': 'keep-alive',
    'Cache-Control': 'max-age=0',
    'Upgrade-Insecure-Requests': '1',
    'Origin': base_url,
    'Referer': base_url
}

# 访问延迟范围（秒）
DELAY_MIN = 1
DELAY_MAX = 3

def random_delay():
    """添加随机延迟"""
    delay = random.uniform(DELAY_MIN, DELAY_MAX)
    time.sleep(delay)

def login(session, username, password):
    """登录论坛"""
    try:
        # 访问登录页面
        login_page_url = main_url + 'member.php?mod=logging&action=login'
        logging.info(f"正在访问登录页面: {login_page_url}")
        r = session.get(login_page_url, headers=headers)
        r.raise_for_status()
        
        soup = BeautifulSoup(r.text, 'html.parser')
        logging.debug(f"登录页面内容: {r.text[:500]}...")
        
        # 获取formhash
        formhash = ''
        formhash_input = soup.find('input', {'name': 'formhash'})
        if formhash_input:
            formhash = formhash_input.get('value', '')
            logging.info(f"获取到formhash: {formhash}")
        else:
            logging.warning("未找到formhash输入框")
            
        # 获取登录表单
        form = soup.find('form', {'id': 'lsform'}) or soup.find('form', {'name': 'login'})
        if form:
            logging.info("找到登录表单")
            action_url = form.get('action', '')
            if action_url:
                # 确保action_url包含/main/
                if not action_url.startswith('/'):
                    action_url = '/main/' + action_url
                elif not action_url.startswith('/main/'):
                    action_url = '/main' + action_url
                login_url = urljoin(base_url, action_url)
                logging.info(f"登录提交URL: {login_url}")
        
        # 构建登录数据
        login_data = {
            'formhash': formhash,
            'referer': forum_url,
            'loginfield': 'username',
            'username': username,
            'password': password,
            'questionid': '0',
            'answer': '',
            'cookietime': '2592000'
        }
        
        logging.info("正在提交登录请求...")
        logging.debug(f"登录数据: {login_data}")
        
        # 发送登录请求
        r = session.post(login_url, data=login_data, headers=headers, allow_redirects=True)
        r.raise_for_status()
        
        logging.debug(f"登录响应状态码: {r.status_code}")
        logging.debug(f"登录响应头: {dict(r.headers)}")
        logging.debug(f"登录响应内容: {r.text[:500]}...")
        
        # 验证登录状态
        if '欢迎' in r.text or '退出' in r.text or '成功' in r.text:
            logging.info("登录成功！")
            
            # 尝试访问目标版块验证权限
            test_r = session.get(forum_url, headers=headers)
            if '抱歉，您尚未登录' in test_r.text:
                logging.error("登录状态验证失败")
                return False
            return True
        else:
            logging.error("登录失败，请检查用户名和密码")
            return False
            
    except Exception as e:
        logging.error(f"登录过程出错: {e}")
        return False

def get_html(session, url):
    """获取页面HTML内容"""
    try:
        random_delay()
        logging.info(f"正在请求页面: {url}")
        
        resp = session.get(url, headers=headers, timeout=15)
        resp.raise_for_status()
        resp.encoding = 'utf-8'
        
        logging.info(f"页面请求成功: {url}")
        return resp.text
    except requests.RequestException as e:
        logging.error(f"请求错误 {url}: {e}")
        return None

def extract_thread_urls(soup):
    """提取帖子链接"""
    thread_urls = []
    
    # 查找帖子列表容器
    waterfall = soup.find('ul', id='waterfall')
    if waterfall:
        # 遍历所有帖子
        for thread in waterfall.find_all('li'):
            # 查找帖子链接
            a_tag = thread.find('a', href=True)
            if a_tag:
                thread_url = a_tag['href']
                # 处理相对路径
                if not thread_url.startswith(('http://', 'https://')):
                    if not thread_url.startswith('/'):
                        thread_url = '/main/' + thread_url
                    elif not thread_url.startswith('/main/'):
                        thread_url = '/main' + thread_url
                thread_url = urljoin(base_url, thread_url)
                if thread_url not in thread_urls:
                    thread_urls.append(thread_url)
                    logging.info(f"找到帖子链接: {thread_url}")
    
    # 查找分页链接
    pagination = soup.find('div', class_='pg')
    if pagination:
        for a in pagination.find_all('a'):
            if 'href' in a.attrs and '&page=' in a['href']:
                page_url = a['href']
                if not page_url.startswith(('http://', 'https://')):
                    if not page_url.startswith('/'):
                        page_url = '/main/' + page_url
                    elif not page_url.startswith('/main/'):
                        page_url = '/main' + page_url
                page_url = urljoin(base_url, page_url)
                if page_url not in thread_urls:
                    thread_urls.append(page_url)
                    logging.info(f"找到分页链接: {page_url}")
    
    return thread_urls

def extract_images_from_post(soup):
    """从帖子内容中提取图片"""
    img_urls = []
    
    # 查找所有可能的帖子内容区域
    content_areas = []
    content_areas.extend(soup.find_all('td', class_='t_f'))
    content_areas.extend(soup.find_all('div', class_='pcb'))
    content_areas.extend(soup.find_all('div', id=lambda x: x and x.startswith('postmessage_')))
    content_areas.extend(soup.find_all('div', class_='message'))
    
    # 如果没有找到特定的内容区域，尝试在整个页面中查找
    if not content_areas:
        content_areas = [soup]
    
    for content in content_areas:
        # 查找所有图片元素
        for img in content.find_all(['img', 'a']):
            # 从img标签获取URL
            if img.name == 'img':
                img_url = (img.get('zoomfile') or  # 放大图片
                          img.get('file') or       # 原始图片
                          img.get('src') or        # 标准src
                          img.get('data-src'))     # 延迟加载
            # 从a标签获取URL（有些图片可能包装在链接中）
            else:
                href = img.get('href', '')
                if any(ext in href.lower() for ext in ['.jpg', '.jpeg', '.png', '.gif', '.bmp']):
                    img_url = href
                else:
                    continue
            
            if img_url:
                # 处理相对路径
                if not img_url.startswith(('http://', 'https://')):
                    if not img_url.startswith('/'):
                        img_url = '/main/' + img_url
                    elif not img_url.startswith('/main/'):
                        img_url = '/main' + img_url
                img_url = urljoin(base_url, img_url)
                
                # 过滤无关图片
                if not any(skip in img_url.lower() for skip in [
                    'static/image', 'avatar', 'small', 'icon', 'smile',
                    'common', 'logo', 'banner', 'background', 'template'
                ]):
                    if img_url not in img_urls:
                        img_urls.append(img_url)
                        logging.info(f"找到帖子内图片: {img_url}")
    
    return img_urls

def download_image(session, img_url, referer=None):
    """下载图片"""
    try:
        local_headers = headers.copy()
        if referer:
            local_headers['Referer'] = referer
            
        # 从URL中提取文件名
        img_name = os.path.basename(img_url).split('?')[0]
        if not img_name or '.' not in img_name:
            parts = urlparse(img_url)
            path_parts = parts.path.split('/')
            img_name = path_parts[-1] if path_parts[-1] else f"image_{hash(img_url)}.jpg"
            
        img_path = os.path.join(save_dir, img_name)
        
        if not os.path.exists(img_path):
            random_delay()
            logging.info(f"正在下载图片: {img_url}")
            response = session.get(img_url, headers=local_headers, timeout=15)
            
            # 检查是否是图片内容
            content_type = response.headers.get('content-type', '')
            if not content_type.startswith('image/'):
                logging.warning(f"跳过非图片内容: {img_url} (Content-Type: {content_type})")
                return
                
            # 检查图片大小
            content_length = int(response.headers.get('content-length', 0))
            if content_length < 1024:  # 小于1KB的可能是图标
                logging.warning(f"跳过小图片: {img_url} (Size: {content_length} bytes)")
                return
                
            with open(img_path, 'wb') as f:
                f.write(response.content)
            logging.info(f'已下载: {img_name}')
        else:
            logging.info(f'已存在: {img_name}')
            
    except Exception as e:
        logging.error(f"下载错误 {img_url}: {e}")

def main():
    """主函数"""
    # 创建会话
    session = requests.Session()
    
    # 获取用户输入
    username = input("请输入用户名: ")
    password = input("请输入密码: ")
    
    # 登录
    if not login(session, username, password):
        return
    
    logging.info("开始爬取版块图片...")
    
    # 切换到图片模式
    image_mode_url = forum_url + '&filter=image&orderby=dateline'
    html = get_html(session, image_mode_url)
    if not html:
        logging.error("无法访问版块页面")
        return
        
    visited_urls = set()
    urls_to_visit = {image_mode_url}
    downloaded_images = set()
    
    try:
        while urls_to_visit:
            current_url = urls_to_visit.pop()
            if current_url in visited_urls:
                continue
                
            visited_urls.add(current_url)
            html = get_html(session, current_url)
            if not html:
                continue
                
            soup = BeautifulSoup(html, 'html.parser')
            
            # 保存页面内容以供调试
            with open('debug_page.html', 'w', encoding='utf-8') as f:
                f.write(html)
            
            if '&page=' in current_url or current_url == image_mode_url:  # 这是一个列表页
                # 获取帖子链接
                thread_urls = extract_thread_urls(soup)
                for url in thread_urls:
                    if url not in visited_urls:
                        if '&page=' in url:  # 这是分页链接
                            if url not in urls_to_visit:
                                urls_to_visit.add(url)
                                logging.info(f"添加分页链接: {url}")
                        else:  # 这是帖子链接
                            urls_to_visit.add(url)
                            logging.info(f"添加帖子链接: {url}")
            else:  # 这是一个帖子页
                # 提取帖子中的图片
                img_urls = extract_images_from_post(soup)
                for img_url in img_urls:
                    if img_url not in downloaded_images:
                        download_image(session, img_url, current_url)
                        downloaded_images.add(img_url)
            
            random_delay()  # 添加延迟避免请求过快
    
    except KeyboardInterrupt:
        logging.info("\n用户中断爬取，正在保存已下载内容...")
    except Exception as e:
        logging.error(f"爬取过程出错: {e}")
        import traceback
        logging.error(traceback.format_exc())
    finally:
        logging.info(f"爬取完成！共下载 {len(downloaded_images)} 张图片")
        logging.info(f"访问过的URL数量: {len(visited_urls)}")
        logging.info(f"待访问的URL数量: {len(urls_to_visit)}")

if __name__ == "__main__":
    main()

```
---

## 说明
