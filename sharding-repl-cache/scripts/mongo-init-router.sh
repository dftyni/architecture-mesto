#!/bin/bash
docker compose exec -T mongodb_router mongosh --port 27020 <<EOF
sh.addShard( "replicaset_0/mongodb_shard_000:27000");
sh.addShard( "replicaset_0/mongodb_shard_001:27001");
sh.addShard( "replicaset_0/mongodb_shard_002:27002");
sh.addShard( "replicaset_1/mongodb_shard_100:27100");
sh.addShard( "replicaset_1/mongodb_shard_101:27101");
sh.addShard( "replicaset_1/mongodb_shard_102:27102");
sh.enableSharding("somedb");
sh.shardCollection("somedb.helloDoc", { "name" : "hashed" } )
EOF