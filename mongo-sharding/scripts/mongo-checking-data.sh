#!/bin/bash

###
# Проверка mongos_router
###
docker compose exec -T mongos_router mongosh --port 27020 --quiet <<EOF
use somedb;
db.helloDoc.countDocuments();
exit(); 
EOF

###
# Проверка shard1
###
docker compose exec -T shard1 mongosh --port 27018 --quiet <<EOF
use somedb;
db.helloDoc.countDocuments();
exit(); 
EOF

###
# Проверка shard2
###
docker compose exec -T shard2 mongosh --port 27019 --quiet <<EOF
use somedb;
db.helloDoc.countDocuments();
exit(); 
EOF

