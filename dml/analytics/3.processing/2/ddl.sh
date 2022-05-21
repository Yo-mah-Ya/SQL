#!/usr/bin/env bash


SOURCE_DIR=$(cd $(dirname ${BASH_SOURCE:-$0}) && pwd)
cd ${SOURCE_DIR}

user="postgres"
password="password"
host="localhost"
db="analytics"


ddl_files=($(ls ${SOURCE_DIR}/data))
for f in "${ddl_files[@]}" ; do
    PGPASSWORD=${password} psql -h ${host} -d ${db} -U ${user} -f ${SOURCE_DIR}/data/${f}
done
