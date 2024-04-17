import time
from selenium import webdriver
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.common.by import By
from iosAppScraper import scrapIosApp
from help_functions import set_chrome_options
from kafkaProducer import kafkaproducer

class AppleScraper:
  def __init__(self):
        print("==> src/iosStoreScraper")
        #init selenium drivers   
        self.chrome_options = set_chrome_options()
        #self.options = webdriver.ChromeOptions()
        self.letter_driver = webdriver.Chrome(options=self.chrome_options)
        self.number_driver = webdriver.Chrome(options=self.chrome_options)
        self.link_driver = webdriver.Chrome(options=self.chrome_options)
       # self.driver.maximize_window()
        
        
  def get_links_of_number(self,cur,conn,number):
        self.link_driver.get(number)
        time.sleep(5)
        SCROLL_PAUSE_TIME = 5
        # Get scroll height
        last_height = self.link_driver.execute_script("return document.body.scrollHeight")
        time.sleep(SCROLL_PAUSE_TIME)
        while True:
                # Scroll down to bottom
                self.link_driver.execute_script("window.scrollTo(0, document.body.scrollHeight);")
 
                # Wait to load page
                time.sleep(SCROLL_PAUSE_TIME)
 
                # Calculate new scroll height and compare with last scroll height
                new_height = self.link_driver.execute_script("return document.body.scrollHeight")
                if new_height == last_height:
                    break
                last_height = new_height
        elems = self.link_driver.find_elements(By.XPATH, "//a[@href]")
        #get the links of apps ,scrape them and insert them into the database.
        for elem in elems:
            try:
                if "https://apps.apple.com/de/app/"in elem.get_attribute("href"):
                        
                    ios_app = scrapIosApp(elem.get_attribute("href"))
                    #for googleplay apps later
                    ios_andoid_spiegel_query="insert into store_apps.search_infos VALUES \n(%s,%s);"%("\'"+ios_app["App Title"].replace("\'","\"")+"\'","\'"+ios_app["AppUrl"].replace("\'","\"")+"\'")
                    cur.execute(ios_andoid_spiegel_query,)
                    #the work now
                    ios_app_query  = "insert into store_apps.ios_app(appstore_id,title,description,icon_url,developer,price_in_cent) VALUES \n(%s,%s,%s,%s,%s,%s)on conflict do nothing;"%("\'"+ios_app["StoreID"].replace("\'","\"")+"\'","\'"+ios_app["App Title"].replace("\'","\"")+"\'","\'"+ios_app["Description"].replace("\'","\"")+"\'","\'"+ios_app["Icon"].replace("\'","\"")+"\'","\'"+ios_app["Developer"].replace("\'","\"")+"\'",int(ios_app["Price"]))
                    cur.execute(ios_app_query,)
                    ios_version_query   ="insert into store_apps.ios_app_version(version,review_count,release_date,recent_changes,last_access,is_latest_version,ios_app_id) VALUES \n(%s,%s,%s,%s,CURRENT_TIMESTAMP,%s,(select app_id from store_apps.ios_app order by app_id desc limit 1)) on conflict do nothing;"%("\'"+ios_app["Version"].replace("\'","\"")+"\'",int(ios_app["review_count"]),"\'"+ios_app["Released"].replace("\'","\"")+"\'","\'"+ios_app["recent_changes"].replace("\'","\"")+"\'",True)
                    cur.execute(ios_version_query,)
                    conn.commit()
                    print(". IosApp inserted.. line 41-50 in src/iosStoreScraper.py")
                    print("Sendind Kafka messages...line 51-53 in src/iosStoreScraper.py")
                    kafkaproducer('ios_application_added', 'ios-application',ios_app)
                    kafkaproducer('ios_application_version_added','ios-application',ios_app)
                    # self.list_of_links.append(elem.get_attribute("href"))
            except:
                print("An app does not work!")
                continue
                    
        print("Next IOS Number..")

  def get_numbers_of_letter(self,cur,conn,letter) -> any:
        self.number_driver.get(letter)
        time.sleep(5)
        elems = self.number_driver.find_elements(By.XPATH, "//a[@href]")
        #get the links of the numbers
        for elem in elems:
            if "page=" in elem.get_attribute("href"):
                print("A Number of The letter found.. line 67 in src/iosStoreScraper.py")
                self.get_links_of_number(cur,conn,elem.get_attribute("href"))
        print("Next IOS Letter..")
                    
  def main(self,cur,conn,url) -> any:
        self.letter_driver.get(url)
        print("Driver got the link..")
        #to have enough time to load the page
        time.sleep(5)
        elems = self.letter_driver.find_elements(By.XPATH, "//a[@href]")
        #get the links of the letters
        for elem in elems:
            if ("letter="in elem.get_attribute("href")) and not ("page=" in elem.get_attribute("href")):
                print("Letter found.. line 80 in src/iosStoreScraper.py")
                self.get_numbers_of_letter(cur,conn,elem.get_attribute("href"))
        
        self.letter_driver.close()
        self.number_driver.close()
        self.link_driver.close()
        return
