# resolve dependencies stage
FROM python:3.8 AS builder
COPY requirements.txt .

# install dependencies to the local user directory (eg. /root/.local)
RUN pip install --user -r requirements.txt

COPY ./src .

COPY ./wait-for-it.sh .

RUN ["chmod", "+x", "./wait-for-it.sh"]

CMD ["./wait-for-it.sh", "aqe-mapping-db:5432", "--", "./wait-for-it.sh", "mhealthatlas-keycloak:8443", "-t", "120", "--", "python", "./KafkaListener.py"]
