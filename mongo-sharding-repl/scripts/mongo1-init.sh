#!/bin/bash

###
# Инициализируем Шард-1
###

docker compose exec -T mongodb1_1 mongosh --port 27018 --quiet <<EOF
rs.initiate(
    {
      _id : "mongodb1",
      members: [
        { _id : 0, host : "mongodb1_1:27018" },
        { _id : 1, host : "mongodb1_2:27019" },
        { _id : 2, host : "mongodb1_3:27020" },
      ]
    }
);
EOF