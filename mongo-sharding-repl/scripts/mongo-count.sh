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
\'Shard1 count elements\'
use somedb
db.helloDoc.countDocuments()
EOF

docker compose exec -T shard1 mongosh --port 27018 --quiet <<EOF
\'Shard1 repl count\'
rs.status().members.length
EOF

docker compose exec -T s1mongodb1 mongosh --port 27027 --quiet <<EOF
\'Shard1 repl-1 count elements\'
use somedb
db.helloDoc.countDocuments()
EOF

docker compose exec -T s1mongodb2 mongosh --port 27028 --quiet <<EOF
\'Shard1 repl-2 count elements\'
use somedb
db.helloDoc.countDocuments()
EOF

docker compose exec -T shard2 mongosh --port 27019 --quiet <<EOF
\'Shard2 count elements\'
use somedb
db.helloDoc.countDocuments()
EOF

docker compose exec -T shard2 mongosh --port 27019 --quiet <<EOF
\'Shard2 repl count\'
rs.status().members.length
EOF

docker compose exec -T s2mongodb1 mongosh --port 27037 --quiet <<EOF
\'Shard2 repl-1 count elements\'
use somedb
db.helloDoc.countDocuments()
EOF

docker compose exec -T s2mongodb2 mongosh --port 27038 --quiet <<EOF
\'Shard2 repl-2 count elements\'
use somedb
db.helloDoc.countDocuments()
EOF