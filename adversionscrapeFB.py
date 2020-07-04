from selenium import webdriver
from webdriver_manager.chrome import ChromeDriverManager
from time import time
from selenium.webdriver.common.action_chains import ActionChains
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.common.by import By
from operator import itemgetter
import pandas as pd
import openpyxl
from openpyxl import load_workbook
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.support.ui import WebDriverWait

#driver = webdriver.Chrome(ChromeDriverManager().install())
chrome_options = Options()

# incognito window

chrome_options.add_argument("--incognito")
driver = webdriver.Chrome(executable_path='D:\\chromedriver.exe',chrome_options=chrome_options)

driver.get('https://www.facebook.com/ads/library/?active_status=all&ad_type=all&country=IE&impression_search_field=has_impressions_lifetime&view_all_page_id=148726998530273&sort_data[direction]=desc&sort_data[mode]=relevancy_monthly_grouped')

driver.set_page_load_timeout(20)
driver.maximize_window()
js = "document.getElementsByClassName('.fb_content');"
driver.execute_script(js)
driver.implicitly_wait(45)

'''
mainpage
'''
link3 = driver.find_elements_by_css_selector('#facebook')
data3 = [link.text for link in link3]
print(data3)

'''
count of ads posted
'''
count = driver.find_element_by_class_name('_7gn2')
count = count.text
count = count[1:]
rest = count.split(" ", 1)[0]
print(rest)
rest = int(rest)
driver.implicitly_wait(30)



def scroll():
    #Get scroll height.
    last_height = driver.execute_script("return document.body.scrollHeight")

    end = time() + 35

    while True:

        # Scroll down to the bottom.
        driver.execute_script("window.scrollTo(0, document.body.scrollHeight);")

        # Wait to load the page.
        driver.implicitly_wait(5)

        # Calculate new scroll height and compare with last scroll height.
        new_height = driver.execute_script("return document.body.scrollHeight")

        if time() > end:
            break

    js = "document.getElementsByClassName('.fb_content');"
    driver.execute_script(js)
    driver.implicitly_wait(20)
    links = driver.find_elements_by_css_selector('#facebook')
    datas = [link.text for link in links]
    print(datas)

#Individual ad - drill down
scroll()
df = pd.DataFrame(columns=["ID","ADno","Adver", "Description", "Period","AmountSpent","Impressions" ,"Disclaimer", "Party"])
for x in range(rest):
    showadlinks = driver.find_elements_by_css_selector('._7kfh')
    print(len(showadlinks))
    actions = ActionChains(driver)
    actions.move_to_element(showadlinks[x]).perform()
    showadlinks[x].click()
    link4 = driver.find_elements_by_css_selector('._7j1n')
    data4 = [link.text for link in link4]
    print(data4)

    '''
    multiple versions
    '''
    l1 = [i.split('\n') for i in data4]
    ad_type = list(map(itemgetter(0), l1))
    if ad_type == ['Multiple versions of this ad']:
        ver = driver.find_element_by_css_selector('._3-8i')
        ver = ver.text
        word_list = ver.split()
        ver = word_list[-1]
        print(ver)
        ver = int(ver)
        for y in range(ver-1):
            driver.find_element_by_xpath("//span[text()='Next']/parent::div").click()
            link4 = driver.find_elements_by_css_selector('._7j1n')
            link5 = driver.find_elements_by_css_selector('._7jgc')
            data4 = [link.text for link in link4]
            data5 = [link.text for link in link5]
            print(data4)
            print(data5)
            l1 = [i.split('\n') for i in data4]
            print(l1)

            l2 = [i.split('\n') for i in data5]
            print(l2)
            # extracting ad details
            # ad ID
            ad_id = list(map(itemgetter(2), l2))
            print(ad_id)

            # ad description
            ad_type = list(map(itemgetter(0), l1))
            print(ad_type)
            if ad_type == ['Multiple versions of this ad']:
                ad_description = list(map(itemgetter(8), l1))
            else:
                ad_description = list(map(itemgetter(4), l1))
            print(ad_description)

            # ad period
            ad_period = list(map(itemgetter(1), l2))
            print(ad_period)

            # ad amount spent
            ad_amount = list(map(itemgetter(3), l2))
            print(ad_amount)

            # ad impressions
            ad_imp = list(map(itemgetter(4), l2))
            print(ad_imp)

            # ad disclaimer
            ad_disc = list(map(itemgetter(6), l1))
            print(ad_disc)

            # ad party
            if ad_type == ['Multiple versions of this ad']:
                ad_party = list(map(itemgetter(4), l1))
            else:
                ad_party = list(map(itemgetter(0), l1))
            print(ad_party)

            # appending ad data into data frame
            df = df.append({'ID': ad_id,'ADno': x,'Adver': y, 'Description': ad_description, 'Period': ad_period, 'AmountSpent': ad_amount,
                            'Impressions': ad_imp, 'Disclaimer': ad_disc, 'Party': ad_party}, ignore_index=True)
            print(df)
            df.to_excel('FacebookAdsSF1.xlsx', index=False)

    else:
        print("Only one Version")
    # reload page & scroll
    driver.get('https://www.facebook.com/ads/library/?active_status=all&ad_type=all&country=IE&impression_search_field=has_impressions_lifetime&view_all_page_id=148726998530273&sort_data[direction]=desc&sort_data[mode]=relevancy_monthly_grouped')
    driver.implicitly_wait(10)
    scroll()


driver.close()

