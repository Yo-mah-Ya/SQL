#!/usr/bin/env bash


user="postgres"
password="password"
host="localhost"
db="analytics"

# psql -?

PGPASSWORD=${password} psql -h ${host} -d ${db} -U ${user}
