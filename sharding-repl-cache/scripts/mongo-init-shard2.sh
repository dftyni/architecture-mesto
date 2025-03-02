#!/bin/bash

###
# Инициализируем второй шард, репликация
###

docker compose exec -T shard2 mongosh --port 27019 --quiet <<EOF

rs.initiate(
    {
      _id : "shard2",
      members: [
        { _id : 0, host : "shard2:27019" },
        { _id : 1, host : "shard2-1:27022" },
        { _id : 2, host : "shard2-2:27021" } 
      ]
    }
);
exit();
EOF 