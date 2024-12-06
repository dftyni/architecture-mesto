#!/bin/bash

###
# Очистка бд
###

docker compose exec -T mongos_router mongosh --port 27020 --quiet <<EOF
use somedb;
db.dropDatabase();
db.getName();
EOF