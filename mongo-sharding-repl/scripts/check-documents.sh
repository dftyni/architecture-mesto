#!/bin/bash

###
# Инициализируем конфиги
###
set -e

docker compose exec -T shard1-mongodb1 mongosh --quiet <<EOF
use somedb;
db.helloDoc.countDocuments();
exit();
EOF

docker compose exec -T shard1-mongodb2 mongosh --quiet <<EOF
use somedb;
db.helloDoc.countDocuments();
exit();
EOF

docker compose exec -T shard1-mongodb3 mongosh --quiet <<EOF
use somedb;
db.helloDoc.countDocuments();
exit();
EOF


docker compose exec -T shard2-mongodb1 mongosh --quiet <<EOF
use somedb;
db.helloDoc.countDocuments();
exit();
EOF

docker compose exec -T shard2-mongodb2 mongosh --quiet <<EOF
use somedb;
db.helloDoc.countDocuments();
exit();
EOF

docker compose exec -T shard2-mongodb3 mongosh --quiet <<EOF
use somedb;
db.helloDoc.countDocuments();
exit();
EOF

docker compose exec -T mongos_router mongosh --port 27020 --quiet <<EOF
use somedb;
db.helloDoc.countDocuments();
exit(); 
EOF
