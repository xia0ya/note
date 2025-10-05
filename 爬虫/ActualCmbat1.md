# 爬虫返回白页解决

## 代码

```{python}
## 搭梯子版本
import os
import time
import undetected_chromedriver as uc
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC

- === 禁用系统代理，避免 400 Bad Request ===
os.environ["HTTP_PROXY"] = ""
os.environ["HTTPS_PROXY"] = ""
os.environ["ALL_PROXY"] = ""

- === 配置 undetected_chromedriver ===
options = uc.ChromeOptions()
options.add_argument("--start-maximized")
options.add_argument("--disable-blink-features=AutomationControlled")
options.add_argument("--no-proxy-server")
options.add_argument("--proxy-bypass-list=*cponline.cnipa.gov.cn")
options.add_argument("--disable-gpu")
options.add_argument("--disable-extensions")

- === 启动 Chrome ===
driver = uc.Chrome(options=options)

- === 打开免责声明页面（页面打开比较慢） ===
driver.get("https://pss-system.cponline.cnipa.gov.cn/Disclaimer")

- 下面的同意按钮没点到，但这个页面已经进来了，后面改改应该可以解决。
try:
    time.sleep(3)

    if "Disclaimer" in driver.current_url:
        print("当前是免责声明页面，准备查找‘同意’按钮...")

        # 尝试点击“同意”
        try:
            agree_btn = driver.find_element(By.ID, "agree")
        except:
            agree_btn = None

        if not agree_btn:
            try:
                agree_btn = driver.find_element(By.XPATH, "//input[@value='同意']")
            except:
                pass

        if agree_btn:
            agree_btn.click()
            print("已点击‘同意’按钮")
        else:
            print("未找到按钮，尝试执行 JS 点击...")
            driver.execute_script("""
                let btn = document.querySelector('#agree') || document.querySelector('input[value="同意"]');
                if (btn) btn.click();
            """)

        # 等待跳转到检索页
        WebDriverWait(driver, 20).until(EC.url_contains("seniorSearch"))
        print("已成功进入检索页面")

    else:
        print("已直接进入检索页，无需点击‘同意’")

except Exception as e:
    print("页面加载失败，错误信息：", e)

input("按回车键结束程序（浏览器保持打开，方便调试）...")


## 不搭梯子版本
import os
import time
import undetected_chromedriver as uc
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC

- 禁用系统代理
os.environ["HTTP_PROXY"] = ""
os.environ["HTTPS_PROXY"] = ""
os.environ["ALL_PROXY"] = ""

- 指定本地 ChromeDriver 路径
CHROMEDRIVER_PATH = r"D:\chromedriver\chromedriver.exe"

- 初始化参数
options = uc.ChromeOptions()
options.add_argument("--start-maximized")
options.add_argument("--disable-blink-features=AutomationControlled")
options.add_argument("--no-sandbox")
options.add_argument("--disable-gpu")
options.add_argument("--disable-extensions")

- 启动本地驱动（不访问外网）
driver = uc.Chrome(driver_executable_path=CHROMEDRIVER_PATH, version_main=140, options=options)

- 打开免责声明页面
driver.get("https://pss-system.cponline.cnipa.gov.cn/Disclaimer")

try:
    WebDriverWait(driver, 10).until(EC.presence_of_element_located((By.ID, "agree"))).click()
    print("✅ 已点击‘同意’按钮")
    WebDriverWait(driver, 20).until(EC.url_contains("seniorSearch"))
    print("✅ 已成功进入高级检索页面")
except Exception as e:
    print("⚠️ 页面加载失败，错误信息：", e)

input("🔒 按回车键结束程序（浏览器保持打开）...")

```