#!/bin/bash

###
# Инициализируем роутер и наполняем тестовыми данными
###

docker exec -it mongos_router mongosh --port 27017 --quiet <<EOF
sh.addShard( "shard1/shard1_r0:27018");
sh.addShard( "shard1/shard1_r1:27018");
sh.addShard( "shard1/shard1_r2:27018");
sh.addShard( "shard2/shard2_r0:27018");
sh.addShard( "shard2/shard2_r1:27018");
sh.addShard( "shard2/shard2_r2:27018");
sh.enableSharding("somedb");
sh.shardCollection("somedb.helloDoc", { "name" : "hashed" } )
use somedb
for(var i = 0; i < 1000; i++) db.helloDoc.insert({age:i, name:"ly"+i})
db.helloDoc.countDocuments() 
exit();
EOF 