#!/bin/bash
docker compose exec -T mongodb_shard_0 mongosh --port 27018 <<EOF
rs.initiate(
    {
      _id : "mongodb_shard_0",
      members: [
        { _id : 0, host : "mongodb_shard_0:27018" },
       // { _id : 1, host : "mongodb_shard_1:27019" }
      ]
    }
);
exit();
EOF