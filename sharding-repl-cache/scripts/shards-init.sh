#!/bin/bash

docker compose exec -T shard1_1 mongo --port 27018 <<EOF
rs.initiate(
    {
      _id : "shard1",
      members: [
        { _id : 0, host : "shard1_1:27018" },
        { _id : 1, host : "shard1_2:27018" },
        { _id : 2, host : "shard1_3:27018" }
      ]
    }
);
quit();
EOF

sleep 1

docker compose exec -T shard2_1 mongo --port 27019 <<EOF
rs.initiate(
    {
      _id : "shard2",
      members: [
        { _id : 3, host : "shard2_1:27019" },
        { _id : 4, host : "shard2_2:27019" },
        { _id : 5, host : "shard2_3:27019" }
      ]
    }
);
quit();
EOF