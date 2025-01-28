#!/bin/bash

###
# Инициализируем бд
###

docker compose exec -T mongo_router mongosh --port 27017 <<EOF
use somedb
for(var i = 0; i < 5000; i++) db.helloDoc.insertOne({age:i, name:"ly"+i})
EOF
$SHELL