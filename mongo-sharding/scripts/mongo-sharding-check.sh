#!/bin/bash

###
# Проверка результатов
###

# Проверка общего количества документов:
docker compose exec -T mongos_router mongosh --port 27017 --quiet <<EOF

use somedb;
db.helloDoc.countDocuments() 
EOF

# Проверка количества документов в shard1:
docker compose exec -T shard1 mongosh --port 27022 --quiet <<EOF

use somedb;
db.helloDoc.countDocuments() 
EOF

# Проверка количества документов в shard2:
docker compose exec -T shard2 mongosh --port 27028 --quiet <<EOF

use somedb;
db.helloDoc.countDocuments() 
EOF