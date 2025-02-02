#!/bin/bash

###
# Инициализируем шард 1
###

docker exec -it shard1_r0 mongosh --port 27018 --quiet <<EOF
rs.initiate(
    {
      _id : "shard1",
      members: [
        { _id : 0, host : "shard1_r0:27018" },
        { _id : 1, host : "shard1_r1:27018" },
        { _id : 2, host : "shard1_r2:27018" },
      ]
    }
);
exit();
EOF 