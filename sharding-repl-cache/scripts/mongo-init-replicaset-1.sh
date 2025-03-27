#!/bin/bash
docker compose exec -T mongodb_shard_100 mongosh --port 27100 <<EOF
rs.initiate(
    {
        _id: "replicaset_1", 
        members: [
            {_id: 0, host: "mongodb_shard_100:27100"},
            {_id: 1, host: "mongodb_shard_101:27101"},
            {_id: 2, host: "mongodb_shard_102:27102"}
        ]
    }
)
exit();
EOF