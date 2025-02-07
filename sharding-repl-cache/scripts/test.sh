#!/bin/bash

echo "ПРОВЕРКА:"

echo "----- shard1-n1 -----------------------"
docker compose exec -T shard1-n1 mongosh --port 27018 <<EOF
use somedb;
db.helloDoc.countDocuments();
exit();
EOF
sleep 2

echo "----- shard1-n2 -----------------------"
docker compose exec -T shard1-n2 mongosh --port 27019 <<EOF
use somedb;
db.helloDoc.countDocuments();
exit();
EOF
sleep 2

echo "----- shard1-n3 -----------------------"
docker compose exec -T shard1-n3 mongosh --port 27021 <<EOF
use somedb;
db.helloDoc.countDocuments();
exit();
EOF
sleep 2

echo "----- shard2-n1 -----------------------"
docker compose exec -T shard2-n1 mongosh --port 27016 <<EOF
use somedb;
db.helloDoc.countDocuments();
exit();
EOF
sleep 2

echo "----- shard2-n2 -----------------------"
docker compose exec -T shard2-n2 mongosh --port 27022 <<EOF
use somedb;
db.helloDoc.countDocuments();
exit();
EOF
sleep 2

echo "----- shard2-n3 -----------------------"
docker compose exec -T shard2-n3 mongosh --port 27023 <<EOF
use somedb;
db.helloDoc.countDocuments();
exit();
EOF

echo "Finish"
