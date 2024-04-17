#!/bin/bash

helpFunction()
{
  echo ""
  echo "Usage: $0 -m mode -i iteration"
  echo -e "\t-m Loadtest Mode (base, load)"
  echo -e "\t-i Iteration of Testrun (used for output file/folder name)"
  exit 1 # Exit script after printing help
}

# parse arguments
# shellcheck disable=SC2003
while getopts ":m:i:" opt
do
  case "$opt" in
    m ) mode="$OPTARG" ;;
    i ) iteration="$OPTARG" ;;
    ? ) helpFunction ;; # Print helpFunction in case parameter is non-existent
  esac
done

# Print helpFunction in case requried parameters are empty
if [ -z "$mode" ] || [ -z "$iteration" ];
then
  echo "Not all required parameters given";
  helpFunction
fi

case "$mode" in
    base ) testplan="MHealthAtlas_Baseline_Test_Plan"
           ;;
    load ) testplan="MHealthAtlas_Load_Test_Plan"
           ;;
    * ) echo "Mode $mode is unknown."
        helpFunction
        ;;
  esac


docker stop /app-debezium-connect
docker stop /taxonomy-debezium-connect
docker stop /mhealthatlas-apps-db
docker stop /mhealthatlas-taxonomies-db
docker stop /mhealthatlas-enterprise-apps-db

docker rm /app-debezium-connect
docker rm /taxonomy-debezium-connect
docker rm /mhealthatlas-apps-db
docker rm /mhealthatlas-taxonomies-db
docker rm /mhealthatlas-enterprise-apps-db

cd ./../../../../../../c/Installer/ || exit

echo '["mhealthatlas-application-outbox-connector",{"server":"mhealthatlas-application-outbox"}]#' | ./kafka_2.13-2.7.0/bin/kafka-console-producer.sh --bootstrap-server kafka:9092 --topic app-debezium_connect_offsets --property "parse.key=true" --property "key.separator=#"
echo '["mhealthatlas-taxonomy-outbox-connector",{"server":"mhealthatlas-taxonomy-outbox"}]#' | ./kafka_2.13-2.7.0/bin/kafka-console-producer.sh --bootstrap-server kafka:9092 --topic taxonomy-debezium_connect_offsets --property "parse.key=true" --property "key.separator=#"

cd ./../../d/Dokumente/Uni/Bachlor/SourceCode/mhealthatlas || exit

docker-compose -f ./docker-compose.yml up --build -d app-debezium-connect taxonomy-debezium-connect postgres-mhealthatlas-apps-db postgres-mhealthatlas-taxonomies-db postgres-mhealthatlas-enterprise-apps-db

sleep 60

cd ./../../../../../../c/Installer/ || exit

#./apache-jmeter-5.4.1/bin/jmeter.sh -n -t "../../d/Dokumente/Uni/Bachlor/Thesis/Evaluation/$testplan.jmx" -l "../../d/Dokumente/Uni/Bachlor/Thesis/Evaluation/MHealthAtlas_Load_Test_Plan$iteration.jtl" -e -o "../../d/Dokumente/Uni/Bachlor/Thesis/Evaluation/mHealthAtlas_Load$iteration"
