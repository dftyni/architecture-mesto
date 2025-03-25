#!/bin/bash

###
# Инициализируем Шард-2
###

docker compose exec -T mongodb2_1 mongosh --port 27021 --quiet <<EOF
rs.initiate(
    {
      _id : "mongodb2",
      members: [
        { _id : 0, host : "mongodb2_1:27021" },
        { _id : 1, host : "mongodb2_2:27022" },
        { _id : 2, host : "mongodb2_3:27023" },
      ]
    }
);
EOF