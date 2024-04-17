from selenium.webdriver.chrome.options import Options

def set_chrome_options() -> any:
    """Sets chrome options for Selenium.
    Chrome options for headless browser is enabled.
    """
    print("Sets chrome options for Selenium.")
    chrome_options = Options()
    chrome_options.add_argument('--no-sandbox')
    chrome_options.add_argument('--start-maximized')
    chrome_options.add_argument('--headless')
    chrome_options.add_argument('--disable-gpu')
    chrome_prefs = {}
    chrome_options.experimental_options["prefs"] = chrome_prefs
    chrome_prefs["profile.default_content_settings"] = {"images": 2}
    return chrome_options

def objectChecker(obj)-> any:
    """to clean the unnecessary data(String) and find the right text of an html object"""
    if obj == None:
        return ""
    else:return obj.getText()

def textCleaner(text) -> any:
    """ a function to remove unnecessary spaces from a text  """
    t = list(text)
    if all(map(lambda v: v==" ",t)):return ""
    for a in t[:]:
        if a==' ' or a=="\n":t.remove(a)
        else:break
    t.reverse()
    for a in t[:]:
        if a==" " or a=="\n":t.remove(a)
        else:break
    t.reverse()
    text="".join(t)
    return text
