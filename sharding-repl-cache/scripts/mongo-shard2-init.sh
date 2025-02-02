#!/bin/bash

###
# Инициализируем шард 2
###

docker exec -it shard2_r0 mongosh --port 27018 --quiet <<EOF
rs.initiate(
    {
      _id : "shard2",
      members: [
        { _id : 0, host : "shard2_r0:27018" },
        { _id : 1, host : "shard2_r1:27018" },
        { _id : 2, host : "shard2_r2:27018" }
      ]
    }
);
exit(); 
EOF 