#!/usr/bin/env bash

SOURCE_DIR=$(cd $(dirname ${BASH_SOURCE:-$0}) && pwd)
cd ${SOURCE_DIR}

DOCKER_IMAGE='psql:latest'
DOCKER_CONTAINER_NAME='psql_container'


user="postgres"
password="password"
host="localhost"
postgres_db="postgres"
analytics_db="analytics"

case "$1" in
    "build") docker image build -t ${DOCKER_IMAGE} .;;
    "login")
        docker container exec \
            -it ${DOCKER_CONTAINER_NAME} \
            /bin/sh -c \
            "PGPASSWORD=${password} psql -h ${host} -d ${analytics_db} -U ${user}";;
    "ddl")
        docker container exec \
            -it ${DOCKER_CONTAINER_NAME} \
            /bin/sh -c \
            "PGPASSWORD=${password} psql -h ${host} -d ${postgres_db} -U ${user} -l | grep ${analytics_db}"
        if [ $? -ne 0 ] ; then
            docker container exec \
                -it ${DOCKER_CONTAINER_NAME} \
                /bin/sh -c \
                "PGPASSWORD=${password} psql -h ${host} -d ${postgres_db} -U ${user} -f ./db.sql"
        fi
        docker container exec -it ${DOCKER_CONTAINER_NAME} /bin/bash -c ". $2";;
    "rmc")docker container rm -f ${DOCKER_CONTAINER_NAME};;
    "rmi")docker image rm -f ${DOCKER_IMAGE};;
    "run")
        docker container run \
            -d \
            -p 5432:5432 \
            -v db-store:/var/lib/postgresql/data \
            --name ${DOCKER_CONTAINER_NAME} \
            ${DOCKER_IMAGE};;
esac
