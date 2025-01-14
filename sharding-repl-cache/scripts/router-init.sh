#!/bin/bash

docker compose exec -T mongos_router mongo --port 27020 <<EOF
sh.addShard( "shard1/shard1_1:27018,shard1_2:27018,shard1_3:27018");
sh.addShard( "shard2/shard2_1:27019,shard2_2:27019,shard2_3:27019");
sh.enableSharding("somedb");
sh.shardCollection("somedb.helloDoc", { "name" : "hashed" } );
use somedb;
for(var i = 0; i < 1000; i++) db.helloDoc.insert({age:i, name:"ly"+i});
db.helloDoc.countDocuments({});
quit();
EOF
