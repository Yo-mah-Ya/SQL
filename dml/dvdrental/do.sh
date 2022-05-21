#!/usr/bin/env bash

SOURCE_DIR=$(cd $(dirname ${BASH_SOURCE:-$0}) && pwd)
cd ${SOURCE_DIR}

DOCKER_IMAGE='psql:latest'
DOCKER_CONTAINER_NAME='psql_container'


user="postgres"
password="password"
host="localhost"
postgres_db="postgres"
dvdrental_db="dvdrental"


function run(){
    if [ $( docker ps -a -f name=${DOCKER_CONTAINER_NAME} | wc -l ) -eq 2 ]; then
        echo "${DOCKER_CONTAINER_NAME} exists"
        docker container rm -f ${DOCKER_CONTAINER_NAME}
    fi
    docker container run \
        -d \
        -p 5432:5432 \
        --name ${DOCKER_CONTAINER_NAME} \
        ${DOCKER_IMAGE}
    if [ $? -ne 0 ] ; then
        echo "Failed to create ${DOCKER_CONTAINER_NAME}"
        exit 1
    fi
    # avoid from executing container just after running container
    sleep 1
}

function create_database(){
    docker container exec \
        -it ${DOCKER_CONTAINER_NAME} \
        /bin/sh -c \
        "PGPASSWORD=${password} psql -h ${host} -d ${postgres_db} -U ${user} -f ./db.sql"
}

function create_table_and_insert(){
    TABLES=(
    language
    actor
    film
    category
    film_actor
    inventory
    film_category
    country
    city
    address
    staff
    customer
    store
    rental
    payment
    )

    for table in "${TABLES[@]}"; do
        docker container exec -it ${DOCKER_CONTAINER_NAME} /bin/bash -c \
            "PGPASSWORD=${password} psql -h ${host} -d ${dvdrental_db} -U ${user} -f ./${table}/ddl.sql"
        if [ $? -ne 0 ] ; then
            echo "failed to create table ${table}"
            continue
        fi
        docker container exec -it ${DOCKER_CONTAINER_NAME} /bin/bash -c \
            "PGPASSWORD=${password} psql -h ${host} -d ${dvdrental_db} -U ${user} -f ./${table}/insert.sql"
    done
}

case "$1" in
    "build") docker image build -t ${DOCKER_IMAGE} .;;
    "login")
        docker container exec \
            -it ${DOCKER_CONTAINER_NAME} \
            /bin/sh -c \
            "PGPASSWORD=${password} psql -h ${host} -d ${dvdrental_db} -U ${user}";;
    "ci")
        run
        create_database
        create_table_and_insert;;
    "query")
        query=$(cat $2)
        docker container exec \
            -it ${DOCKER_CONTAINER_NAME} \
            /bin/sh -c \
            "PGPASSWORD=${password} psql -h ${host} -d ${dvdrental_db} -U ${user} -c \"${query}\"";;
    "rmc")docker container rm -f ${DOCKER_CONTAINER_NAME};;
    "rmi")
        docker image rm -f ${DOCKER_IMAGE};;
    "run")
        run;;
esac
