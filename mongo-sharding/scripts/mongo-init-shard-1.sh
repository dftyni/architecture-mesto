#!/bin/bash
docker compose exec -T mongodb_shard_1 mongosh --port 27019  <<EOF
rs.initiate(
    {
      _id : "mongodb_shard_1",
      members: [
       // { _id : 0, host : "mongodb_shard_0:27018" },
        { _id : 1, host : "mongodb_shard_1:27019" }
      ]
    }
  );
exit(); 
EOF