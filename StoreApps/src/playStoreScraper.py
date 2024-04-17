import time
from selenium import webdriver
from selenium.webdriver.common.by import By
from help_functions import set_chrome_options
class GoogleScraper:
    def __init__(self):
        print("==> src/playStoreScraper")
        #init selenium driver and lists for to save the results in
        self.chrome_options = set_chrome_options()
        self.driver = webdriver.Chrome(options=self.chrome_options)
        self.links_list=[]
        
    def scraper(self,page) -> any:
        if page =="" :return 
        self.driver.get(page)
        time.sleep(10)
        SCROLL_PAUSE_TIME = 5
        # Get scroll height
        last_height = self.driver.execute_script("return document.body.scrollHeight")
        time.sleep(SCROLL_PAUSE_TIME)
        while True:
                # Scroll down to bottom
                self.driver.execute_script("window.scrollTo(0, document.body.scrollHeight);")

                # Wait to load page
                time.sleep(SCROLL_PAUSE_TIME)
                # Calculate new scroll height and compare with last scroll height
                new_height = self.driver.execute_script("return document.body.scrollHeight")
                if new_height == last_height:
                    break
                last_height = new_height

       #get all links of the website
        elems = self.driver.find_elements(By.XPATH, "//a[@href]")
        if elems == None: return 
        for i,elem in enumerate(elems):
            #get the links of the apps and save them in a list
            if "details?id" in elem.get_attribute("href"):
                if not (elem.get_attribute("href") in self.links_list):
                    self.links_list.append(elem.get_attribute("href"))
                    time.sleep(3)
        #close the browser
        self.driver.close()
        return self.links_list
