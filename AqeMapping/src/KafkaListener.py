from kafka import KafkaConsumer
import json
import os
import AqeCommandService

kafka_server = os.environ.get('KAFKA_SERVER')
group_id = os.environ.get('KAFKA_GROUP_ID')
topics = ['android-application', 'ios-application', 'private-application', 'user-management', 'rating']
supportedEventTypes = ['android_application_deleted', 'android_application_version_added', 'android_application_added', 'android_application_version_taxonomy_class_added',
  'android_application_version_taxonomy_class_deleted', 'ios_application_deleted', 'ios_application_version_added', 'ios_application_added', 'private_application_deleted',
  'ios_application_version_taxonomy_class_added', 'ios_application_version_taxonomy_class_deleted', 'private_application_version_added', 'private_application_added',
  'private_application_version_taxonomy_class_added', 'private_application_version_taxonomy_class_deleted', 'questionnaire_added', 'questionnaire_status_changed',
  'questionnaire_deleted', 'question_added', 'user_specialization_mapping_verified', 'user_specialization_mapping_challenged', 'user_specialization_mapping_deleted',
  'user_role_mapping_created', 'user_role_mapping_deleted', 'user_deleted', 'rating_added' ]


def supportedEvent(headers) -> bool:
  for header in headers:
    if (header[0] == 'eventType'):
      if str(header[1], 'utf8') in supportedEventTypes:
        return True
  return False

def handleKafkaMessage(message: bytes) -> None:
  jsonObj = json.loads(message)
  payload = jsonObj['payload'] if 'schema' in jsonObj else jsonObj
  if ('eventType' not in payload or 'eventData' not in payload):
    return

  if 'android_application_deleted' == payload['eventType']:
    AqeCommandService.handleDeletedApp(json.loads(payload['eventData']))
    return
  if 'android_application_version_added' == payload['eventType']:
    AqeCommandService.handleNewAppVersion(json.loads(payload['eventData']))
    return
  if 'android_application_added' == payload['eventType']:
    AqeCommandService.handleNewApp(json.loads(payload['eventData']))
    return
  if 'android_application_version_taxonomy_class_added' == payload['eventType']:
    AqeCommandService.handleAddedAppVersionTaxonomyClass(json.loads(payload['eventData']))
    return
  if 'android_application_version_taxonomy_class_deleted' == payload['eventType']:
    AqeCommandService.handleDeletedAppVersionTaxonomyClass(json.loads(payload['eventData']))
    return
  if 'ios_application_deleted' == payload['eventType']:
    AqeCommandService.handleDeletedApp(json.loads(payload['eventData']))
    return
  if 'ios_application_version_added' == payload['eventType']:
    AqeCommandService.handleNewAppVersion(json.loads(payload['eventData']))
    return
  if 'ios_application_added' == payload['eventType']:
    AqeCommandService.handleNewApp(json.loads(payload['eventData']))
    return
  if 'ios_application_version_taxonomy_class_added' == payload['eventType']:
    AqeCommandService.handleAddedAppVersionTaxonomyClass(json.loads(payload['eventData']))
    return
  if 'ios_application_version_taxonomy_class_deleted' == payload['eventType']:
    AqeCommandService.handleDeletedAppVersionTaxonomyClass(json.loads(payload['eventData']))
    return
  if 'private_application_deleted' == payload['eventType']:
    AqeCommandService.handleDeletedApp(json.loads(payload['eventData']))
    return
  if 'private_application_version_added' == payload['eventType']:
    AqeCommandService.handleNewAppVersion(json.loads(payload['eventData']))
    return
  if 'private_application_added' == payload['eventType']:
    AqeCommandService.handleNewApp(json.loads(payload['eventData']))
    return
  if 'private_application_version_taxonomy_class_added' == payload['eventType']:
    AqeCommandService.handleAddedAppVersionTaxonomyClass(json.loads(payload['eventData']))
    return
  if 'private_application_version_taxonomy_class_deleted' == payload['eventType']:
    AqeCommandService.handleDeletedAppVersionTaxonomyClass(json.loads(payload['eventData']))
    return
  if 'questionnaire_added' == payload['eventType']:
    AqeCommandService.handleNewQuestionnaire(json.loads(payload['eventData']))
    return
  if 'questionnaire_status_changed' == payload['eventType']:
    AqeCommandService.handleChangedQuestionnaireStatus(json.loads(payload['eventData']))
    return
  if 'questionnaire_deleted' == payload['eventType']:
    AqeCommandService.handleDeletedQuestionnaire(json.loads(payload['eventData']))
    return
  if 'question_added' == payload['eventType']:
    AqeCommandService.handleNewQuestion(json.loads(payload['eventData']))
    return
  if 'user_specialization_mapping_verified' == payload['eventType']:
    AqeCommandService.handleVerifiedUserSpecialization(json.loads(payload['eventData']))
    return
  if 'user_specialization_mapping_challenged' == payload['eventType']:
    AqeCommandService.handleChallangedUserSpecialization(json.loads(payload['eventData']))
    return
  if 'user_specialization_mapping_deleted' == payload['eventType']:
    AqeCommandService.handleDeletedUserSpecialization(json.loads(payload['eventData']))
    return
  if 'user_deleted' == payload['eventType']:
    AqeCommandService.handleDeletedUser(json.loads(payload['eventData']))
    return
  if 'user_role_mapping_deleted' == payload['eventType']:
    AqeCommandService.handleDeletedUserRole(json.loads(payload['eventData']))
    return
  if 'user_role_mapping_created' == payload['eventType']:
    AqeCommandService.handleAddedUserRole(json.loads(payload['eventData']))
    return
  if 'rating_added' == payload['eventType']:
    AqeCommandService.handleChangedRating(json.loads(payload['eventData']))
    return
  return

if __name__ == '__main__':
  print('''init kafka consumer:
    topics: {}
    group id: {}
    bootstrap servers: {}'''.format(', '.join(topics), group_id, kafka_server))
  consumer = KafkaConsumer(*topics, group_id=group_id, bootstrap_servers=[kafka_server])
  print('kafka consumer created, starts listing for messages')
  for msg in consumer:
    print("New Kafka Message: {}".format(msg))
    if supportedEvent(msg.headers):
      handleKafkaMessage(msg.value)

  print('close kafka consumer')
  if consumer is not None:
    consumer.close()
