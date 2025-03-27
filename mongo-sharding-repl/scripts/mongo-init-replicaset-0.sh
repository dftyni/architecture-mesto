#!/bin/bash
docker compose exec -T mongodb_shard_000 mongosh --port 27000 <<EOF
rs.initiate(
    {
        _id: "replicaset_0", 
        members: [
            {_id: 0, host: "mongodb_shard_000:27000"},
            {_id: 1, host: "mongodb_shard_001:27001"},
            {_id: 2, host: "mongodb_shard_002:27002"}
        ]
    }
)
exit();
EOF