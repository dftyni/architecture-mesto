#!/bin/bash

###
# Проверка сколько всего документов в mongos_router
###
docker compose exec -T mongos_router mongosh --port 27020 --quiet <<EOF
use somedb;
print("Количество документов: " + db.helloDoc.countDocuments());
exit(); 
EOF

###
# Проверка количества документов в shard1
###
docker compose exec -T shard1-replica1 mongosh --port 27021 --quiet <<EOF
use somedb;
print("Количество документов: " + db.helloDoc.countDocuments());
exit(); 
EOF

###
# Проверка количества документов в shard2
###
docker compose exec -T shard2-replica1 mongosh --port 27024 --quiet <<EOF
use somedb;
print("Количество документов: " + db.helloDoc.countDocuments());
exit(); 
EOF

###
# Проверка количества реплик в shard1
###
docker compose exec -T shard1-replica1 mongosh --port 27021 --quiet <<EOF
print("Количество реплик: " + rs.status().members.length);
exit(); 
EOF

###
# Проверка количества реплик в shard2
###
docker compose exec -T shard2-replica1 mongosh --port 27024 --quiet <<EOF
print("Количество реплик: " + rs.status().members.length);
exit();
EOF
