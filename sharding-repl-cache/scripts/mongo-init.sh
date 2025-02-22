#!/bin/bash

###
# Инициализируем бд
###

docker-compose exec configSrv sh -c "mongosh < /scripts/config-server-init.js"
sleep 5
docker-compose exec shard1_1 sh -c "mongosh < /scripts/shard1-init.js"
sleep 5
docker-compose exec shard2_1 sh -c "mongosh < /scripts/shard2-init.js"
sleep 5
docker-compose exec mongos_router sh -c "mongosh --port 27020 < /scripts/router-init.js"
sleep 5

printf "Router: \n"
docker compose exec -T mongos_router mongosh --port 27020 <<EOF
use somedb
db.helloDoc.remove({});
for(var i = 0; i < 1000; i++) db.helloDoc.insertOne({age:i, name:"ly"+i})
db.helloDoc.countDocuments();
EOF

printf "Shard1: \n"
docker compose exec -T shard1_1 mongosh <<EOF
use somedb
db.helloDoc.countDocuments();
EOF

printf "Shard2: \n"
docker compose exec -T shard2_1 mongosh <<EOF
use somedb
db.helloDoc.countDocuments();
EOF

