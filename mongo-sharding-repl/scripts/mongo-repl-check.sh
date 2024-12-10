#!/bin/bash

###
# Проверка результатов
###

# Проверка общего количества документов:
docker compose exec -T mongos_router mongosh --port 27017 --quiet <<EOF

use somedb;
db.helloDoc.countDocuments() 
EOF

# Проверка количества документов в shard1-1:
docker compose exec -T shard1-1 mongosh --port 27022 --quiet <<EOF

use somedb;
db.helloDoc.countDocuments() 
EOF

# Проверка количества документов в shard1-2:
docker compose exec -T shard1-2 mongosh --port 27023 --quiet <<EOF

use somedb;
db.helloDoc.countDocuments() 
EOF

# Проверка количества документов в shard1-3:
docker compose exec -T shard1-3 mongosh --port 27024 --quiet <<EOF

use somedb;
db.helloDoc.countDocuments() 
EOF

# Проверка количества реплик в shard1:
docker compose exec -T shard1-1 mongosh --port 27022 --quiet <<EOF

rs.status().members.length
EOF

# Проверка количества документов в shard2-1:
docker compose exec -T shard2-1 mongosh --port 27028 --quiet <<EOF

use somedb;
db.helloDoc.countDocuments() 
EOF

# Проверка количества документов в shard2-2:
docker compose exec -T shard2-2 mongosh --port 27029 --quiet <<EOF

use somedb;
db.helloDoc.countDocuments() 
EOF

# Проверка количества документов в shard2-3:
docker compose exec -T shard2-3 mongosh --port 27030 --quiet <<EOF

use somedb;
db.helloDoc.countDocuments() 
EOF

# Проверка количества реплик в shard2:
docker compose exec -T shard2-1 mongosh --port 27028 --quiet <<EOF

rs.status().members.length
EOF