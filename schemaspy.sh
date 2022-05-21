#!/usr/bin/env bash

user="postgres"
password="password"
host="localhost"
port='5432'
if [ -z $1 ] ; then
    echo "pass me database name"
    exit 1
fi
database=$1

docker container run \
    --rm \
    --net="host" \
    -v "${PWD}/output:/output" \
    schemaspy/schemaspy:latest \
        -t pgsql11 \
        -host ${host} \
        -port ${port} \
        -db ${database} \
        -u ${user} \
        -p ${password} \
        -s public
