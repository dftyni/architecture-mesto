#!/bin/bash
docker compose exec -T mongodb_router mongosh --port 27020 <<EOF
sh.addShard( "mongodb_shard_0/mongodb_shard_0:27018");
sh.addShard( "mongodb_shard_1/mongodb_shard_1:27019");
sh.enableSharding("somedb");
sh.shardCollection("somedb.helloDoc", { "name" : "hashed" } )
EOF