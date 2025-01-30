#!/bin/bash

docker compose exec -T mongo_config_server mongosh --port 27017 <<EOF
rs.initiate(
  {
    _id : "config_server",
       configsvr: true,
    members: [
      { _id : 0, host : "mongo_config_server:27017" }
    ]
  }
);
EOF

docker compose exec -T mongodb1 mongosh --port 27018 <<EOF
rs.initiate({_id: "mongodb1", members: [
  {_id: 0, host: "mongodb1:27018"},
  {_id: 1, host: "mongodb1_0:27021"},
  {_id: 2, host: "mongodb1_1:27022"}
]});
EOF

docker compose exec -T mongodb2 mongosh --port 27019 <<EOF
rs.initiate({_id: "mongodb2", members: [
  {_id: 0, host: "mongodb2:27019"},
  {_id: 1, host: "mongodb2_0:27023"},
  {_id: 2, host: "mongodb2_1:27024"}
]});
EOF

docker compose exec -T mongos_router mongosh --port 27020 <<EOF
sh.addShard( "mongodb1/mongodb1:27018");
sh.addShard( "mongodb2/mongodb2:27019");

sh.enableSharding("somedb");
sh.shardCollection("somedb.helloDoc", { "name" : "hashed" } )

use somedb

for(var i = 0; i < 1000; i++) db.helloDoc.insert({age:i, name:"ly"+i})
EOF