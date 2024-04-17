'''this script is to search andriod apps with help of ios apps,and that is why it is a very expensive process'''
from time import sleep
import requests
from kafkaProducer import kafkaproducer
from bs4 import BeautifulSoup as bs4
from andriodAppScraper import scrapAndroidApp
from playStoreScraper import GoogleScraper
from help_functions import objectChecker
from iosAppScraper import scrapIosApp

def main(cur,conn):
    #we need an extra table with following informations:
    cur.execute("select title from search_infos")
    search_infos=cur.fetchall()
    for i in search_infos:
      search_insert_app(i[0],cur,conn)

def search_insert_app(title,cur,conn):
    link="https://play.google.com/store/search?q="+title+"&c=apps"
    i = 0
    playScraper=GoogleScraper()
    apps = playScraper.scraper(link)
    for app in apps:
      try:
        sc=scrap_category(app)
        if sc in ["Medizin","Medical","Health & Fitness","Gesundheit & Fitness"] :
          android_app=scrapAndroidApp(app)
          android_app_query  = "insert into store_apps.android_app(playstore_id,title,description,icon_url,developer,price_in_cent) VALUES \n(%s,%s,%s,%s,%s,%s)on conflict do nothing;"%("\'"+android_app["StoreID"].replace("\'","\"")+"\'","\'"+android_app["App Title"].replace("\'","\"")+"\'","\'"+android_app["Description"].replace("\'","\"")+"\'","\'"+android_app["Icon"].replace("\'","\"")+"\'","\'"+android_app["Developer"].replace("\'","\"")+"\'",android_app["Price"])
          cur.execute(android_app_query,)
          conn.commit()
          android_version_query   ="insert into store_apps.android_app_version(version,review_count,release_date,recent_changes,last_access,is_latest_version,android_app_id) VALUES \n(%s,%s,%s,%s,CURRENT_TIMESTAMP,%s,(select app_id from store_apps.android_app order by app_id desc limit 1)) on conflict do nothing;"%("\'"+android_app["Version"].replace("\'","\"")+"\'",int(android_app["review_count"]),"\'"+android_app["Released"].replace("\'","\"")+"\'","\'"+android_app["recent_changes"].replace("\'","\"")+"\'",True)
          cur.execute(android_version_query,)
          conn.commit()
          print(". AndriodApp scraped and inserted.. line 23-33 in src/playStoreScraper.py")
          print("Sendind Kafka messages...line 56-58 in src/playStoreScraper.py")
          kafkaproducer('android_application_added','android-application',android_app)
          kafkaproducer('android_application_version_added','android-application',android_app)
          sleep(3)
        else:print("Not the right app,start analysing the next one..")
      except:
        #print("An app does not work!!")
        continue
  
#fast scraping jsut to find the right app:
#a function to scrap just title, category of an app     
#a sub from the main scraper from (src/andriodAppScraper.py) 
def scrap_category(app_link):
    r = requests.get(app_link)
    r.raise_for_status()
    app_page = bs4(r.content,"html.parser")  
    #App Category
    app_catigury = objectChecker(app_page.findAll("a",{"class":"hrTbp R8zArc"})[1])
    return app_catigury
'''
#just for fast testing!
def search_my_app(title):
    link="https://play.google.com/store/search?q="+title+"&c=apps"
    i = 0
    playScraper=GoogleScraper()
    apps = playScraper.scraper(link)
    for app in apps:
      sc=scrap_category(app)
      if (sc in ["Medizin","Medical","Health & Fitness","Gesundheit & Fitness"]):
        i += 1
        print(i,app)
    else:print(" Not the right app ..")

ios_app=scrapIosApp("https://apps.apple.com/de/app/wolo-fitness/id1575838510")
search_my_app(ios_app["App Title"])
'''
