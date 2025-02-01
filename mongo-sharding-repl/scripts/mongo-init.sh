#!/bin/bash

###
# Инициализируем кофиг сервер
###
docker compose exec -T configSrv-r1 mongosh --port 27019 --quiet <<EOF
rs.initiate({
    _id : "config_server",
    configsvr: true,
    members: [
        { _id : 0, host : "configSrv-r1:27019" },
        { _id : 1, host : "configSrv-r2:27019" },
        { _id : 2, host : "configSrv-r3:27019" },
    ]
});
exit
EOF

###
# Инициализируем шард 1
###
docker compose exec -T mongodb1-r1 mongosh --port 27018 --quiet <<EOF
rs.initiate({
    _id : "shard1",
    members: [
        { _id : 0, host : "mongodb1-r1:27018" },
        { _id : 1, host : "mongodb1-r2:27018" },
        { _id : 2, host : "mongodb1-r3:27018" },
    ]
});
exit
EOF

###
# Инициализируем шард 2
###
docker compose exec -T mongodb2-r1 mongosh --port 27018 --quiet <<EOF
rs.initiate({
    _id : "shard2",
    members: [
        { _id : 0, host : "mongodb2-r1:27018" },
        { _id : 1, host : "mongodb2-r2:27018" },
        { _id : 2, host : "mongodb2-r3:27018" },
    ]
});
exit
EOF

###
# Инициализируем бд
###

docker compose exec -T mongos_router mongosh --quiet <<EOF

sh.addShard("shard1/mongodb1-r1:27018,mongodb1-r2:27018,mongodb1-r3:27018");
sh.addShard("shard2/mongodb2-r1:27018,mongodb2-r2:27018,mongodb2-r3:27018");

sh.enableSharding("somedb");

sh.shardCollection("somedb.helloDoc", { "name" : "hashed" } )

use somedb
for(var i = 0; i < 1000; i++) db.helloDoc.insertOne({age:i, name:"ly"+i})
exit
EOF


docker compose exec -T mongodb1-r1 mongosh --port 27018 --quiet <<EOF
use somedb
db.helloDoc.countDocuments()
EOF


docker compose exec -T mongodb2-r1 mongosh --port 27018 --quiet <<EOF
use somedb
db.helloDoc.countDocuments()
EOF