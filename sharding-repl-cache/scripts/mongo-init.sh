#!/bin/bash

###
# Инициализация сервера конфигураций
###
echo config
docker compose exec -T configSrv mongosh --port 27020 <<EOF
rs.initiate({
    _id: "config_server",
    configsvr: true,
    members: [{ _id : 0, host : "configSrv:27020" }]
})
EOF

###
# Инициализация шардов
###
echo shard1
docker compose exec -T shard1_node1 mongosh --port 27018 <<EOF
rs.initiate({
    _id: "shard1",
    members: [
        { _id: 0, host: "shard1_node1:27018" },
        { _id: 1, host: "shard1_node2:27021" },
        { _id: 2, host: "shard1_node3:27022" }
    ]
})
EOF

echo shard2
docker compose exec -T shard2_node1 mongosh --port 27019 <<EOF
rs.initiate({
    _id : "shard2",
    members: [
        { _id: 0, host: "shard2_node1:27019" },
        { _id: 1, host: "shard2_node2:27023" },
        { _id: 2, host: "shard2_node3:27024" }
    ]
})
EOF

sleep 3

echo mongo-router
docker compose exec -T mongos mongosh --port 27017 <<EOF
sh.addShard("shard1/shard1_node1:27018")
sh.addShard("shard2/shard2_node1:27019")
sh.enableSharding("somedb")
sh.shardCollection("somedb.helloDoc", {"name": "hashed"})
use somedb
for (var i = 0; i < 1000; i++) db.helloDoc.insert({age:i, name:"ly"+i})
db.helloDoc.countDocuments()
EOF
