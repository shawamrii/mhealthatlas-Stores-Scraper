import unidecode
from bs4 import BeautifulSoup as bs
import requests
from datetime import datetime
from help_functions import objectChecker
        
def scrapAndroidApp(app_link):#scrap the app page
    #get the link of the app in BeautifulSoup Function to start the scraping
    if app_link == "":return []
    r = requests.get(app_link)
    r.raise_for_status()
    app_page = bs(r.content,"html.parser")   
    if(app_page is None): return []
    #Store Id
    store_text = str(app_page.find("meta",{"name":"appstore:bundle_id"}))
    store_id = store_text.split("content=")[1].split('"')[1]
    #App Age
    app_age = app_page.find("div",{"class":"KmO8jd"})
    app_age =objectChecker(app_age)
    #App Title
    app_title = app_page.find("h1",{"class":"AHFaub"}).find("span")
    app_title=(objectChecker(app_title))
    
    #App Icon
    app_icon = app_page.find("img",{"class":"T75of sHb2Xb"})
    if app_icon != None: app_icon = app_icon.get("src")      
    #App Categurie
    app_catigurie = objectChecker(app_page.findAll("a",{"class":"hrTbp R8zArc"})[1])
    #App Summary
    app_summary1=app_page.find("div",{"jsname":"sngebd"})
    app_summary = objectChecker(app_summary1)
    #recent_changes
    app_news = app_page.find("div",{"class":"DWPxHb"})
    app_news = objectChecker(app_news)
    #review_count
    if app_page.find("span",{"class":"AYi5wd TBRnV"}) == None:
      review_count=0
    else:  
      review_count = app_page.find("span",{"class":"AYi5wd TBRnV"}).find("span",{"class":""})
      if review_count == None:
       review_count = 0
      else:
        review_count = int(float(objectChecker(review_count).replace(",","")))
    #DeveloperId
    app_entwickler = objectChecker(app_page.find("a",{"class":"hrTbp R8zArc"}))
    entwickler_id = app_page.find("a",{"class":"hrTbp R8zArc"}).get("href").split("?id=")[1]
    #App Price 
    # get the price(String) and turn it into integer
    app_price = objectChecker(app_page.find("span",{"class":"oocvOe"}))
    if  app_price=="Install":
      app_price = 0
    else:
      #unidecode to get the "utf-8" format(ggf.)
      app_price_0 =unidecode.unidecode(app_price)
      app_price = ""
      for a in app_price_0:
        if a.isdigit():
          app_price += str(a)
        else:continue
      if app_price =="":app_price =0  
      else:app_price = int(float(app_price)*100)
    
    # infos below the page like developer, size, etc..
    extra_infos = app_page.findAll("div",{"class":"hAyfc"}) 
    app_release =  datetime.now()
    app_size = ""
    app_version = ""
    entwickler_adress = ""
    entwickler_email = ""
    entwickler_webpage = ""
    app_policy = ""
    
    #find the rest Informations        
    for info in extra_infos:
        my_info = info.find("div",{"class":"BgcNfc"})
        info_name =objectChecker(my_info)
        if info_name == "Updated":
          app_release = datetime.strptime(objectChecker(my_info.parent()[-1]),"%B %d, %Y")
        if info_name == "Size":
          app_size = objectChecker(my_info.parent()[-1])
        if info_name == "Current Version":
          app_version = objectChecker(my_info.parent()[-1])
        if info_name == "Developer":
          entwickler_infos = my_info.parent()
          links=[]
          #developer informations(links) in a list
          for i in entwickler_infos:
            if i.get("href") != None:
              links.append(i.get("href"))
            else:
              #just text ,that we dont need(not adress but something else)
              if "olicy" in objectChecker(i) or "@" in objectChecker(i) or "Develop" in objectChecker(i) or "ebsite" in objectChecker(i):continue
              #developer Adress
              else: entwickler_adress=objectChecker(i)
           #delete duplicate in the list
          my_list=list(dict.fromkeys(links))
          for j in my_list:
            #save the elements of the list in the right Developer Variables 
            #developer email
            if "@" in j:  
              entwickler_email = j.replace("mailto","").replace(":","")
           #develoer app Privacy
            elif "olicy" in j or "rivacy" in j:
              app_policy = j
              #developer website
            else:entwickler_webpage = j
	#version_id & app_id are not found
    return {"StoreID":store_id,"AppId":0,"App Title":app_title,"AppUrl":app_link,"Category":app_catigurie,"Age":app_age,"Icon":app_icon,"Size":app_size,"Version":app_version,"VersionId":0,"Released":app_release,"Description":app_summary,"recent_changes":app_news,"review_count":review_count,"Price":app_price,"Developer":app_entwickler,"DeveloperId":entwickler_id,"DeveloperWebsite":entwickler_webpage,"DeveloperEmail":entwickler_email,"DeveloperAdress":entwickler_adress,"Policy":app_policy}
