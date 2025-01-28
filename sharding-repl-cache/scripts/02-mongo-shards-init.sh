#!/bin/bash

###
# Инициализируем шарды с репликами
###

# shard1

docker compose exec -T mongo_shard1 mongosh --port 27019 <<EOF
rs.initiate({
    _id : "shard1",
    members: [
      { _id: 0, host: "mongo_shard1:27019" },
      { _id: 1, host: "mongo_shard1_repl:27021" }
    ]
});
EOF

# shard2

docker compose exec -T mongo_shard2 mongosh --port 27020 <<EOF
rs.initiate({
    _id : "shard2",
    members: [
      { _id: 0, host: "mongo_shard2:27020" },
      { _id: 1, host: "mongo_shard2_repl:27022" }
    ]
});
EOF

$SHELL