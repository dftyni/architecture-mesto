#!/bin/bash

###
# Количство элементов на шардах и в сумме
###

docker compose exec -T mongos_router mongosh --port 27020 --quiet <<EOF
\'Total elements\'
use somedb
db.helloDoc.countDocuments()
EOF

docker compose exec -T shard1 mongosh --port 27018 --quiet <<EOF
\'Shard1 count\'
use somedb
db.helloDoc.countDocuments()
EOF

docker compose exec -T shard1 mongosh --port 27018 --quiet <<EOF
\'Shard1 repl count\'
rs.status().members.length
EOF

docker compose exec -T shard2 mongosh --port 27019 --quiet <<EOF
\'Shard2 count\'
use somedb
db.helloDoc.countDocuments()
EOF

docker compose exec -T shard2 mongosh --port 27019 --quiet <<EOF
\'Shard2 repl count\'
rs.status().members.length
EOF