#!/bin/bash

###
# Инициализируем кофиг сервер
###
docker compose exec -T configSrv mongosh --quiet <<EOF
rs.initiate({
    _id : "config_server",
    configsvr: true,
    members: [
        { _id : 0, host : "configSrv:27017" }
    ]
});
EOF

###
# Инициализируем шард 1
###
docker compose exec -T mongodb1 mongosh --port 27018 --quiet <<EOF
rs.initiate({
    _id : "shard1",
    members: [
        { _id : 0, host : "mongodb1:27018" }
    ]
});
EOF

###
# Инициализируем шард 2
###
docker compose exec -T mongodb2 mongosh --port 27019 --quiet <<EOF
rs.initiate({
    _id : "shard2",
    members: [
        { _id : 0, host : "mongodb2:27019" }
    ]
});
EOF


###
# Инициализируем бд
###

docker compose exec -T mongos_router mongosh --port 27020 --quiet <<EOF

sh.addShard("shard1/mongodb1:27018");
sh.addShard("shard2/mongodb2:27019");

sh.enableSharding("somedb");

sh.shardCollection("somedb.helloDoc", { "name" : "hashed" } )

use somedb
for(var i = 0; i < 1000; i++) db.helloDoc.insertOne({age:i, name:"ly"+i})
EOF


docker compose exec -T mongodb1 mongosh --port 27018 --quiet <<EOF
use somedb
db.helloDoc.countDocuments()
EOF


docker compose exec -T mongodb2 mongosh --port 27019 --quiet <<EOF
use somedb
db.helloDoc.countDocuments()
EOF