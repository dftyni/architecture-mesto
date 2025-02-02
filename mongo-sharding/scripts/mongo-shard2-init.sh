#!/bin/bash

###
# Инициализируем шард 2
###

docker exec -it shard2 mongosh --port 27018 --quiet <<EOF
rs.initiate(
    {
      _id : "shard2",
      members: [
        { _id : 1, host : "shard2:27018" }
      ]
    }
);
exit(); 
EOF 