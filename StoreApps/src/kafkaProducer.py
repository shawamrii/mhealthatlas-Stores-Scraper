from time import sleep
from json import dumps
import os
from kafka import KafkaProducer

topics = ['android-application', 'ios-application', 'private-application']
events = ['android_application_added','private_application_added','ios_application_added','android_application_version_added','ios_application_version_added','private_application_version_added','aktiv']
kafka_server = os.environ.get('KAFKA_SERVER')
def kafkaproducer(event,topic,app) -> None:
  producer = KafkaProducer(bootstrap_servers=[kafka_server],
                         value_serializer=lambda x:
                         dumps(x).encode('utf-8'))
  try:
    if (event in events) and (app != None):
      data={event:app}
      producer.send(topic,value=data)
      sleep(5)
      producer.flush()
      producer.close()
      return
    else:
      data={'fehler':None}
      producer.send(topic,value=data)
      sleep(5)
      producer.flush()
      producer.close()
      return
  except KafkaError as exc:
    print_error("Exception during subscribing to topics - {}".format(exc))
    return
