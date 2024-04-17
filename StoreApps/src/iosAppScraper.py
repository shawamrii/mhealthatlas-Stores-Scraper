import requests
from bs4 import BeautifulSoup as bs
import unidecode
from datetime import datetime
from help_functions import objectChecker,textCleaner

def scrapIosApp(app_link):#scrap the app page
    #get the link of the app in BeautifulSoup Function to start the scraping
    if app_link == "":return None
    r = requests.get(app_link)
    r.raise_for_status()
    app_page = bs(r.content,"html.parser")   
    if(app_page is None): return None
        
    #Store Id
    store_text = app_page.find("script",{"id":"shoebox-media-api-cache-apps"})
    store_text=objectChecker(store_text)
    store_id = store_text.split("bundleId")[1].split("hasInAppPurchases")[0][5:-5]
    
    #Store Id
    app_id = store_text.split("apps.")[1].split(".")[0]
    #Version Id
    version_id = int(float(store_text.split("VersionId")[1].split("supportURLForLanguage")[0].split(",")[0][3:]))
    #App Age
    app_age = app_page.find("span",{"class":"badge badge--product-title"})
    app_age =objectChecker(app_age)
    app_title_age = app_page.find("h1",{"class":"product-header__title app-header__title"})
    app_title_age =objectChecker(app_title_age)
    #App Title
    app_title = unidecode.unidecode(textCleaner(app_title_age.replace(app_age,"")))
    if app_page.source !=None :
        app_icon_urls = app_page.source.get("srcset")
    #App Icon
    app_icon = app_icon_urls[:app_icon_urls.find("1x,")]
    #review_count
    #we get it string and then turn it into integer
    review_count = app_page.find("figcaption",{"class":"we-rating-count star-rating__count"})
    review_count=objectChecker(review_count)
    if review_count == "" :
      review_count=0
    else:
      review_count = unidecode.unidecode(review_count).split("*")
      if len(review_count)>1:
        review_count=review_count[1].split(" Bewertung")[0]
      else:
       review_count = review_count[0]
    #App Summary
    app_summary = app_page.find("div",{"class":"section__description"})
    app_summary = objectChecker(app_summary)
    #app_news
    app_news =app_page.find("section",{"class":"l-content-width section section--bordered whats-new"})
    if app_news == None: app_news=""
    else:
      app_news = app_news.find("div",{"class":"l-row whats-new__content"})
      if app_news== None:
        app_news = objectChecker(app_news)
      else:
        app_news = app_news.find("div",{"class":"l-column small-12 medium-9 large-8 small-valign-top"})
        if app_news == None:
          app_news = objectChecker(app_news)
        else: app_news = objectChecker(app_news).replace("\n",".")
    #App Price 
    #we get it string and then turn it into integer      
    app_price = app_page.find("li",{"class":"inline-list__item inline-list__item--bulleted app-header__list__item--price"})#
    if  objectChecker(app_price)==["Gratis","Free"] :
      app_price = 0
    else:
      app_price_0 =unidecode.unidecode(objectChecker(app_price))
      app_price = ""
      for a in app_price_0:
        if a.isdigit():
          app_price += str(a)
        else:continue
      if app_price =="":app_price =0  
      else:app_price = int(float(app_price)*100)
      #App version
    app_version = app_page.find("p",{"class":"l-column small-6 medium-12 whats-new__latest__version"})
    app_version = objectChecker(app_version).replace("Version ","")
    
        #App Datenschutz
    app_policy = app_page.find("section",{"class":"l-content-width section section--bordered app-privacy"}).find("p").find("a")
    if app_policy != None :
        app_policy = app_policy.get("href")
    else:app_policy = ""
   #infos below the app webpage in a list
    app_infos=(app_page.find("section",{"class":"l-content-width section section--bordered section--information"})).find("dl").findAll("dd")
    info_list = []
    for info in app_infos[:]:
        if info == None : continue
        clean_info =(info.getText()).split("\n")            
        for x in list(clean_info):
            x=textCleaner(x)
            if x=="" or x=="\n" or "    " in x:continue
            info_list.append(x)
        
    #App Anbieter
    app_Anbieter = info_list[0]
    #App Size
    app_size = unidecode.unidecode(info_list[1])
    #App Catigorie
    app_catigurie = info_list[2]
    #App Website der Entwickler
    entwickler_webpage = app_page.find("a",{"class":"link icon icon-after icon-external"}).get("href")
    #App Release Date
    #date is in german..but english is needed 
    app_release = app_page.find("time")
    app_release = objectChecker(app_release)
    if app_release=="":app_release = datetime.now()
    else:
      app_release = app_release.replace(".","")
      app_release =datetime.strptime( app_release.replace("Dez","Dec").replace("Mär","Mar").replace("Okt","Oct").replace("Sept","Sep").replace("Januar","Jan").replace("Februar","Feb").replace("März","Mar").replace("Marz","Mar").replace("April","Apr").replace("Mai","May").replace("Juni","Jun").replace("Juli","Jul").replace("August","Aug").replace("Septemper","Sep").replace("Oktober","Oct").replace("November","Nov").replace("Dezember","Dec"),"%d %b %Y")
    

    app_entwickler1 = app_page.find("h2",{"class":"product-header__identity app-header__identity"})
    #App Developer
    app_entwickler = textCleaner(objectChecker(app_entwickler1))
    #developer Id
    entwickler_id = int(float(str(app_entwickler1).split('''"targetId":''')[1].split('"')[1]))
    return  {"StoreID":store_id,"AppId":app_id,"App Title":app_title,"AppUrl":app_link,"Category":app_catigurie,"Age":app_age, "Icon":app_icon,"Size":app_size,"Version":app_version,"VersionId":version_id,"Released":app_release,"Description":app_summary,"recent_changes":app_news,"review_count":review_count,"Price":app_price,"Developer":app_entwickler,"DeveloperId":entwickler_id,"DeveloperWebsite":entwickler_webpage,"DeveloperEmail":"","DeveloperAdress":"","Policy":app_policy} 
