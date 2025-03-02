#!/bin/bash

###
# Инициализируем первый шард, репликация
###

docker compose exec -T shard1 mongosh --port 27018 --quiet <<EOF

rs.initiate(
    {
      _id : "shard1",
      members: [
        { _id : 0, host : "shard1:27018" },
        { _id : 1, host : "shard1-1:27024" },
        { _id : 2, host : "shard1-2:27023" }
      ]
    }
);
exit();
EOF 