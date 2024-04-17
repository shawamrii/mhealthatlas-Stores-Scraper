from dataclasses import asdict
import sys
from typing import Any
import uuid
import json
import logging
import psycopg2
from psycopg2.extras import LoggingConnection
import os
from AppType import AppType
from RatingEventDto import RatingEventDto
from RatingIdEventDto import RatingIdEventDto
from TaxonomyClassEventDto import TaxonomyClassEventDto

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
        host=os.environ.get("DB_HOST"),
        port=os.environ.get("DB_PORT"),
        database=os.environ.get("DB_NAME"),
        user=os.environ.get("DB_USERNAME"),
        password=os.environ.get("DB_PASSWORD"),
    )
    conn.initialize(logger)

    print("Database connection established")
    return conn


def fetchTaxonomyClassId(taxonomyClass, cur) -> Any:
  taxonomyClassId = None
  if taxonomyClass["layer2CategoryId"] is None:
    cur.execute("""select taxonomy_class_id from aqe_mapping.taxonomy_class where layer0_category_id = %s and layer1_category_id is null
      and layer2_category_id is null and layer3_category_id is null and layer4_category_id is null
      and layer5_category_id is null and layer6_category_id is null and layer7_category_id is null""", (taxonomyClass["layer1CategoryId"],),)

  if taxonomyClass["layer2CategoryId"] is not None and taxonomyClass["layer3CategoryId"] is None:
    cur.execute("""select taxonomy_class_id from aqe_mapping.taxonomy_class where layer0_category_id = %s and layer1_category_id = %s
      and layer2_category_id is null and layer3_category_id is null and layer4_category_id is null
      and layer5_category_id is null and layer6_category_id is null and layer7_category_id is null""", (taxonomyClass["layer1CategoryId"],
      taxonomyClass["layer2CategoryId"]),)

  if taxonomyClass["layer2CategoryId"] is not None and taxonomyClass["layer3CategoryId"] is not None:
    cur.execute("""select taxonomy_class_id from aqe_mapping.taxonomy_class where layer0_category_id = %s and layer1_category_id = %s
      and layer2_category_id = %s and layer3_category_id = %s and layer4_category_id = %s
      and layer5_category_id = %s and layer6_category_id = %s and layer7_category_id = %s""",
        (taxonomyClass["layer1CategoryId"], taxonomyClass["layer2CategoryId"], taxonomyClass["layer3CategoryId"],
        taxonomyClass["layer4CategoryId"], taxonomyClass["layer5CategoryId"], taxonomyClass["layer6CategoryId"],
        taxonomyClass["layer7CategoryId"], taxonomyClass["layer8CategoryId"]),)

  if cur.rowcount > 0:
    taxonomyClassId = cur.fetchone()[0]

  if taxonomyClassId is None:
    cur.execute("""insert into aqe_mapping.taxonomy_class(layer0_category_id, layer1_category_id, layer2_category_id,
      layer3_category_id, layer4_category_id, layer5_category_id, layer6_category_id, layer7_category_id)
      values(%s, %s, %s, %s, %s, %s, %s, %s) returning taxonomy_class_id""", (taxonomyClass["layer1CategoryId"],
      taxonomyClass["layer2CategoryId"], taxonomyClass["layer3CategoryId"], taxonomyClass["layer4CategoryId"],
      taxonomyClass["layer5CategoryId"], taxonomyClass["layer6CategoryId"], taxonomyClass["layer7CategoryId"],
      taxonomyClass["layer8CategoryId"]),)
    taxonomyClassId = cur.fetchone()[0]

  return taxonomyClassId


# this method could trigger some logic to assign an expert with a new verified specification an application
# and publish the corresponding event
def handleVerifiedUserSpecialization(userData) -> None:
    conn = initConn()
    print("transaction started")
    with conn:
        with conn.cursor() as cur:
            print("Insert expert specialization:")
            cur.execute(
                "insert into aqe_mapping.expert_specialization(expert_id, specialization_id) values(%s, %s);",
                (userData["userId"], userData["specializationId"]),
            )
    print("transaction committed")
    conn.close()
    return


# if the specialization was allready verified, than we should check in the future if the expert have assigned ratings
# decission between remove ratings or only remove not submitted ratings -> publish event with deleted ratings
def handleChallangedUserSpecialization(userData) -> None:
    conn = initConn()
    print("transaction started")
    with conn:
        with conn.cursor() as cur:
            print("Delete Expert Specialization:")
            cur.execute(
                "delete from aqe_mapping.expert_specialization where expert_id = %s and specialization_id = %s;",
                (userData["userId"], userData["specializationId"]),
            )
    print("transaction committed")
    conn.close()
    return


# if the specialization was allready verified, than we should check in the future if the expert have assigned ratings
# decission between remove ratings or only remove not submitted ratings -> publish event with deleted ratings
def handleDeletedUserSpecialization(userData) -> None:
    conn = initConn()
    print("transaction started")
    with conn:
        with conn.cursor() as cur:
            print("Delete Expert Specialization:")
            cur.execute(
                "delete from aqe_mapping.expert_specialization where expert_id = %s and specialization_id = %s;",
                (userData["userId"], userData["specializationId"]),
            )
    print("transaction committed")
    conn.close()
    return


# we should check in the future if the user is expert and have assigned ratings
# decission between remove ratings or only remove not submitted ratings -> publish event with deleted ratings
def handleDeletedUser(userData) -> None:
    conn = initConn()
    print("transaction started")
    with conn:
        with conn.cursor() as cur:
            print("Delete Expert:")
            cur.execute(
                "delete from aqe_mapping.expert where expert_id = %s;",
                (userData["userId"],),
            )
    print("transaction committed")
    conn.close()
    return


# we should check in the future if the user is expert and have assigned ratings
# decission between remove ratings or only remove not submitted ratings -> publish event with deleted ratings
def handleDeletedUserRole(userData) -> None:
    conn = initConn()
    print("transaction started")
    with conn:
        with conn.cursor() as cur:
            if userData["roleName"] == "Expert":
                print("Delete Expert:")
                cur.execute(
                    "delete from aqe_mapping.expert where expert_id = %s;",
                    (userData["userId"],),
                )
    print("transaction committed")
    conn.close()
    return


def handleAddedUserRole(userData) -> None:
    conn = initConn()
    print("transaction started")
    with conn:
        with conn.cursor() as cur:
            if userData["roleName"] == "Expert":
                print("Count Expert:")
                cur.execute(
                    "select count(expert_id) from aqe_mapping.expert where expert_id = %s;",
                    (userData["userId"],),
                )

                if cur.fetchone()[0] == 0:
                    print("Insert Expert:")
                    cur.execute(
                        "insert into aqe_mapping.expert(expert_id) values(%s);",
                        (userData["userId"],),
                    )
    print("transaction committed")
    conn.close()
    return


def handleNewQuestionnaire(questionnaireData) -> None:
    conn = initConn()
    print("transaction started")
    with conn:
        with conn.cursor() as cur:
            print("Inserted new questionnaire into the database:")
            cur.execute(
                "insert into aqe_mapping.questionnaire(questionnaire_id, is_valid) values(%s, %s);",
                (questionnaireData["id"], questionnaireData["isValid"]),
            )

            for taxonomyClass in questionnaireData["taxonomyClasses"]:
                print("Inserted new questionnaire taxonomy class into the database:")
                cur.execute(
                    "insert into aqe_mapping.questionnaire_taxonomy_class(questionnaire_id, taxonomy_class_id) values(%s, %s);",
                    (questionnaireData["id"], fetchTaxonomyClassId(taxonomyClass, cur)),
                )
    print("transaction committed")
    conn.close()
    return


def handleChangedQuestionnaireStatus(questionnaireData) -> None:
    conn = initConn()
    print("transaction started")
    with conn:
        with conn.cursor() as cur:
            print("update questionnaire status:")
            cur.execute(
                "update aqe_mapping.questionnaire set is_valid = %s where questionnaire_id = %s;",
                (questionnaireData["isValid"], questionnaireData["id"]),
            )
    print("transaction committed")
    conn.close()
    return


def handleDeletedQuestionnaire(questionnaireData) -> None:
    conn = initConn()
    print("transaction started")
    with conn:
        with conn.cursor() as cur:
            print("delete questionnaire from the database:")
            cur.execute(
                "delete from aqe_mapping.questionnaire where questionnaire_id = %s;",
                (questionnaireData["id"],),
            )
    print("transaction committed")
    conn.close()
    return


def handleNewQuestion(questionData) -> None:
    conn = initConn()
    print("transaction started")
    with conn:
        with conn.cursor() as cur:
            print("Inserted new question into the database:")
            cur.execute(
                "insert into aqe_mapping.question(question_id, questionnaire_id, discipline_id) values(%s, %s, %s);",
                (
                    questionData["id"],
                    questionData["questionnaireId"],
                    questionData["disciplineId"],
                ),
            )
    print("transaction committed")
    conn.close()
    return


def handleChangedRating(questionData) -> None:
    conn = initConn()
    print("transaction started")
    with conn:
        with conn.cursor() as cur:
            print("Update aqe mapping:")
            cur.execute(
                "update aqe_mapping.application_question_expert set rating_pending = false where id = %s;",
                (questionData["ratingId"],),
            )
    print("transaction committed")
    conn.close()
    return


def handleNewApp(appData) -> None:
    conn = initConn()
    print("transaction started")
    with conn:
        with conn.cursor() as cur:
            print("Inserted new application version into the database:")
            cur.execute(
                "insert into aqe_mapping.application_version(application_version_id, application_id, application_type, is_payed) values(%s, %s, %s, false);",
                (appData["appVersionId"], appData["appId"], appData["appType"]),
            )
    print("transaction committed")
    conn.close()
    return


def handleNewAppVersion(appData) -> None:
    conn = initConn()
    print("transaction started")
    with conn:
        with conn.cursor() as cur:
            print("Inserted new application version into the database:")
            cur.execute(
                "insert into aqe_mapping.application_version(application_version_id, application_id, application_type, is_payed) values(%s, %s, %s, false);",
                (appData["appVersionId"], appData["appId"], appData["appType"]),
            )
    print("transaction committed")
    conn.close()
    return

def handleDeletedApp(appData) -> None:
    conn = initConn()
    print("transaction started")
    with conn:
        with conn.cursor() as cur:
            print("select application question expert mapping ids from the database:")
            cur.execute(
                """select aqe.id, q.questionnaire_id from aqe_mapping.application_question_expert aqe
                   left join aqe_mapping.question q on q.question_id = aqe.question_id
                   where aqe.application_taxonomy_class_id in (
                     select atc.id from aqe_mapping.application_taxonomy_class atc
                     left join aqe_mapping.application_version av on av.id = atc.application_version_id
                     where av.application_id = %s and av.application_type = %s);""",
                (appData["appId"], appData["appType"]),
            )

            ratingIds = cur.fetchall()
            print(
                "Returned Rating Ids: {}".format(
                    ", ".join(str(r[0]) for r in ratingIds)
                )
            )

            print("insert outbox event:")
            cur.executemany(
                """insert into aqe_mapping.outbox (event_id, version, root_aggregate_type, root_aggregate_id, aggregate_type, aggregate_id, event_type, payload)
                           values(%s, %s, %s, %s, %s, %s, %s, %s);""",
                map(
                    lambda r: (
                        str(uuid.uuid4()),
                        1,
                        "rating",
                        r[1],
                        "rating",
                        r[0],
                        "rating_deleted",
                        json.dumps(RatingIdEventDto(r[0]).__dict__),
                    ),
                    ratingIds,
                ),
            )

            print("delete outbox event:")
            cur.executemany(
                """delete from aqe_mapping.outbox where aggregate_id = %s and event_type = %s;""",
                map(lambda r: ((str) (r[0]), "rating_deleted"), ratingIds),
            )

            print("Delete application from the database:")
            cur.execute(
                "delete from aqe_mapping.application_version where application_id = %s and application_type = %s;",
                (appData["appId"], appData["appType"]),
            )
    print("transaction committed")
    conn.close()
    return

def handleAddedAppVersionTaxonomyClass(appData) -> None:
    conn = initConn()

    print("transaction started")
    with conn:
        with conn.cursor() as cur:
            print("Select application version id from the database:")
            cur.execute(
                "select id from aqe_mapping.application_version where application_version_id = %s and application_type = %s;",
                (appData["appVersionId"], appData["appType"]),
            )

            appId = cur.fetchone()[0]
            print("Returned application Id: {}".format(appId))

            print("insert new application taxonomy class id into the database:")
            cur.execute(
                "insert into aqe_mapping.application_taxonomy_class (application_version_id, taxonomy_class_id) values(%s, %s)",
                (appId, fetchTaxonomyClassId(appData, cur)),
            )

            insertAqeMapping(appData, cur)
    print("transaction committed")
    conn.close()
    return


# in the future we should remove ratings for the deleted application version taxonomy class
# decission between all or only not answered ratings -> publish rating deleted events
def handleDeletedAppVersionTaxonomyClass(appData) -> None:
    conn = initConn()

    print("transaction started")
    with conn:
        with conn.cursor() as cur:
            print("Select application version id from the database:")
            cur.execute(
                "select id from aqe_mapping.application_version where application_version_id = %s and application_type = %s;",
                (appData["appVersionId"], appData["appType"]),
            )

            appId = cur.fetchone()[0]
            print("Returned application Id: {}".format(appId))

            print("Delete old application version taxonomy class from the database:")
            cur.execute(
                "delete from aqe_mapping.application_taxonomy_class where application_version_id = %s and taxonomy_class_id = %s;",
                (appId, fetchTaxonomyClassId(appData, cur)),
            )
    print("transaction committed")
    conn.close()
    return

# Add additional attribute to application_question_expert table
# the attribute should contain all relevant specalication of an expert for the specific rating (array of integer) <- maybe array of foreign keys (currently in development for postgresql)
def insertAqeMapping(appData, cur) -> None:
    print("Select application version id from the database:")
    cur.execute(
        """select atc.id from aqe_mapping.application_taxonomy_class atc
           left join aqe_mapping.application_version av on av.id = atc.application_version_id
           where av.application_version_id = %s and av.application_type = %s and atc.taxonomy_class_id = %s;""",
        (appData["appVersionId"], appData["appType"], fetchTaxonomyClassId(appData, cur)),)

    appTaxonomyId = cur.fetchone()[0]
    print("Returned application Id: {}".format(appTaxonomyId))

    print(
        "Count for application id {} the application question expert mappings:".format(
            appTaxonomyId
        )
    )
    cur.execute(
        "select count(id) from aqe_mapping.application_question_expert where application_taxonomy_class_id = %s",
        (appTaxonomyId,),
    )

    aqeMappingCount = cur.fetchone()[0]

    if aqeMappingCount == 0:
        print("Select newest questionnaire:")
        cur.execute(
            "select questionnaire_id from aqe_mapping.questionnaire where is_valid = true order by questionnaire_id desc limit 1;"
        )

        questionnaireId = cur.fetchone()[0]
        print("Returned questionnaire Id: {}".format(questionnaireId))

        print("Select the 5 newest added experts:")
        cur.execute(
            "select expert_id from aqe_mapping.expert order by expert_id desc limit 5"
        )

        expertIds = cur.fetchall()
        print(
            "Returned Expert Ids: {}".format(
                ", ".join(map(lambda e: str(e[0]), expertIds))
            )
        )

        print("insert application question expert mappings:")
        cur.executemany(
            """insert into aqe_mapping.application_question_expert (application_taxonomy_class_id, question_id, expert_id, rating_pending)
                        select %s, question_id, %s, true from aqe_mapping.question where questionnaire_id = %s;""",
            map(lambda e: (appTaxonomyId, e[0], questionnaireId), expertIds),
        )

        print(
            "Select for application taxonomy class id {} the application question expert mappings:".format(
                appTaxonomyId
            )
        )
        cur.execute(
            "select id, question_id, expert_id from aqe_mapping.application_question_expert where application_taxonomy_class_id = %s",
            (appTaxonomyId,),
        )

        aqeMappings = cur.fetchall()
        print(
            "Returned Application Question Expert Mappings: {}".format(
                ", ".join(
                    map(
                        lambda aqe: "({}, {}, {})".format(aqe[0], aqe[1], aqe[2]),
                        aqeMappings,
                    )
                )
            )
        )

        print("insert outbox event:")
        cur.executemany(
            """insert into aqe_mapping.outbox (event_id, version, root_aggregate_type, root_aggregate_id, aggregate_type, aggregate_id, event_type, payload)
                        values(%s, %s, %s, %s, %s, %s, %s, %s);""",
            map(
                lambda aqe: (
                    str(uuid.uuid4()),
                    1,
                    "rating",
                    questionnaireId,
                    "rating",
                    aqe[0],
                    "rating_planned",
                    json.dumps(
                        RatingEventDto(
                            aqe[0],
                            appData["appVersionId"],
                            appData["appId"],
                            appData["appType"],
                            asdict(TaxonomyClassEventDto(appData["layer1CategoryId"], appData["layer2CategoryId"],
                              appData["layer3CategoryId"], appData["layer4CategoryId"], appData["layer5CategoryId"],
                              appData["layer6CategoryId"], appData["layer7CategoryId"], appData["layer8CategoryId"])),
                            aqe[1],
                            aqe[2],
                            None,
                        ).__dict__
                    ),
                ),
                aqeMappings,
            ),
        )

        print("delete outbox event:")
        cur.executemany(
            """delete from aqe_mapping.outbox where aggregate_id = %s and event_type = %s;""",
            map(lambda aqe: (str(aqe[0]), "rating_planned"), aqeMappings),
        )
    else:
        print("Mapping allready exists")
    return
