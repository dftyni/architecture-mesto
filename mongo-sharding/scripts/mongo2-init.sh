#!/bin/bash

###
# Инициализируем Шард-2
###

docker compose exec -T mongodb2 mongosh --port 27019 --quiet <<EOF
rs.initiate(
    {
      _id : "mongodb2",
      members: [
        { _id : 0, host : "mongodb2:27019" }
      ]
    }
);
EOF