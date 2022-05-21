#!/usr/bin/env bash

docker container run -it --rm -v $PWD:/sql sqlfluff/sqlfluff:latest \
    fix \
        --force \
        --FIX-EVEN-UNPARSABLE \
        --dialect postgres \
        $1
