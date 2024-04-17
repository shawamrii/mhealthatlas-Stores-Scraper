import logging
import os
import psycopg2
from psycopg2.extras import LoggingConnection
from iosStoreScraper import AppleScraper
import android_ios_mirror

logger = logging.getLogger(__name__)
logger.setLevel(level=logging.DEBUG)
handler = logging.StreamHandler()
handler.setLevel(logging.DEBUG)
logger.addHandler(handler)

def initConn() -> any:
    print(
        "Try to establish a database connection with the parametes: DB_HOST {host}, DB_PORT: {port}, DB_NAME: {name}, DB_USERNAME: {username}, DB_PASSWORD: *****".format(
            host=os.environ.get("DB_HOST"),
            port=os.environ.get("DB_PORT"),
            name=os.environ.get("DB_NAME"),
            username=os.environ.get("DB_USERNAME"),
        )
    )
    conn = psycopg2.connect(
        connection_factory=LoggingConnection,
        host="DB_HOST",
        port="DB_PORT",
        database="DB_NAME",
        user="DB_USERNAME",
        password="DB_PASSWORD",
    )
    conn.initialize(logger)

    print("Database connection established")

    return conn

def storeApps() -> any :
    #init a connection
    conn = initConn()
    cur = conn.cursor()
   #start  inserting the apps data into the right (table)
#####################ios app//ios app version############################
    print("Ios Medizin Apps..")
    ios_medizin = AppleScraper()
    ios_medizin.main(cur,conn,"https://apps.apple.com/de/genre/ios-medizin/id6020")
    print("25% done line 46 in src/storeCommandService.py")
    print("Ios Fitness Apps..")
    ios_fitness = AppleScraper()
    ios_fitness.main(cur,conn,"https://apps.apple.com/de/genre/ios-gesundheit-und-fitness/id6013")
    print("50% done line 50 in src/storeCommandService.py\nDone!")

#################andoid  app//andoid version app#########################
    print("Now Andoid Apps searching and inserting...")
    android_ios_mirror().main(cur,conn)
    print("100%..Done")

    #cut the connection
    conn.close()
    print("\nfinish\n")
    return
if __name__ == "__main__":
    storeApps()
