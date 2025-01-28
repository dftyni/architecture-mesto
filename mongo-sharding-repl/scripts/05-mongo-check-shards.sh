#!/bin/bash

###
# Проверяем шарды
###

docker compose exec -T mongo_shard1 mongosh --port 27019 <<EOF
use somedb
db.helloDoc.find().count()
EOF

docker compose exec -T mongo_shard2 mongosh --port 27020 <<EOF
use somedb
db.helloDoc.find().count()
EOF
$SHELL