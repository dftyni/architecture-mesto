#!/bin/bash

echo "---------------------"
echo "Initializing config server"
echo "---------------------"
docker compose exec -T configSrv mongosh --port 27017 <<EOF
rs.initiate({
    _id: "config_server",
    configsvr: true,
    members: [{ _id : 0, host : "configSrv:27017" }]
})
EOF

echo "---------------------"
echo "Initializing shard1"
echo "---------------------"
docker compose exec -T shard1-1 mongosh --port 27018 <<EOF
rs.initiate({
    _id: "rs1", 
    members: 
    [
        {_id: 0, host: "shard1-1:27018"},
        {_id: 1, host: "shard1-2:27021"},
        {_id: 2, host: "shard1-3:27022"}
    ]
}) 
EOF

echo "---------------------"
echo "Initializing shard2"
echo "---------------------"
docker compose exec -T shard2-1 mongosh --port 27019 <<EOF
rs.initiate({
    _id: "rs2", 
    members: 
    [
        {_id: 0, host: "shard2-1:27019"},
        {_id: 1, host: "shard2-2:27023"},
        {_id: 2, host: "shard2-3:27024"}
    ]
}) 
EOF

echo "Wait 3 seconds..."
sleep 3

echo "---------------------"
echo "Adding documents, testing overall count"
echo "---------------------"
docker compose exec -T mongos_router mongosh --port 27020 <<EOF
sh.addShard("rs1/shard1-1:27018")
sh.addShard("rs2/shard2-1:27019")
sh.enableSharding("somedb")
sh.shardCollection("somedb.helloDoc", {"name": "hashed"})
use somedb
for (var i = 0; i < 1000; i++) db.helloDoc.insert({age:i, name:"ly"+i})
db.helloDoc.countDocuments()
EOF

echo "---------------------"
echo "Testing shard1 documents count"
echo "---------------------"
docker compose exec -T shard1-1 mongosh --port 27018 <<EOF
use somedb
db.helloDoc.countDocuments()
EOF

echo "---------------------"
echo "Testing shard2 documents count"
echo "---------------------"
docker compose exec -T shard2-1 mongosh --port 27019 <<EOF
use somedb
db.helloDoc.countDocuments()
EOF
