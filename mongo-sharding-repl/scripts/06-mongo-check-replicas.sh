#!/bin/bash

###
# Проверяем реплики
###

docker compose exec -T mongo_shard1_repl mongosh --port 27021 <<EOF
rs.status()

rs.secondaryOk()
use somedb
db.helloDoc.find().count()
EOF

docker compose exec -T mongo_shard2_repl mongosh --port 27022 <<EOF
rs.status()

rs.secondaryOk()
use somedb
db.helloDoc.find().count()
EOF
$SHELL