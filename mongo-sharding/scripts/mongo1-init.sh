#!/bin/bash

###
# Инициализируем Шард-1
###

docker compose exec -T mongodb1 mongosh --port 27018 --quiet <<EOF
rs.initiate(
    {
      _id : "mongodb1",
      members: [
        { _id : 0, host : "mongodb1:27018" }
      ]
    }
);
EOF