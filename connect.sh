#!/usr/bin/env bash


user="postgres"
password="password"
host="localhost"
db="postgres"

# psql -?

PGPASSWORD=${password} psql -h ${host} -d ${db} -U ${user}
