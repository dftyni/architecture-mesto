#!/bin/bash

# Проверяем общее количество документов

docker exec -i mongosRouter mongosh --port 27020 <<EOF
use somedb;
db.helloDoc.countDocuments();
exit();
EOF

# Проверяем количество документов на шарде 1

docker exec -i shard1 mongosh --port 27018 <<EOF
use somedb;
db.helloDoc.countDocuments();
exit();
EOF

# Проверяем количество документов на шарде 2

docker exec -i shard2 mongosh --port 27019 <<EOF
use somedb;
db.helloDoc.countDocuments();
exit();
EOF
