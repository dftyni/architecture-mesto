#!/bin/bash

###
# Инициализируем БД
###

docker compose exec -T shard1 mongosh --quiet <<EOF
rs.initiate({
  _id: "shard1",
  members: [
    { _id: 0, host: "shard1:27017" },
    { _id: 1, host: "replica1-1:27017" },
    { _id: 2, host: "replica1-2:27017" },
    { _id: 3, host: "replica1-3:27017" }
  ]
});
EOF

docker compose exec -T shard2 mongosh --quiet <<EOF
rs.initiate(
  {
    _id : "shard2",
    members: [
      { _id: 0, host: "shard2:27017" },
      { _id: 1, host: "replica2-1:27017" },
      { _id: 2, host: "replica2-2:27017" },
      { _id: 3, host: "replica2-3:27017" }
    ]
  }
);
EOF

docker compose exec -T configSrv mongosh --quiet <<EOF
rs.initiate(
  {
    _id : "config_server",
    configsvr: true,
    members: [
      { _id: 0, host: "configSrv:27017" }
    ]
  }
);
EOF

sleep 5

docker compose exec -T mongos_router mongosh --quiet <<EOF
sh.addShard("shard1/shard1:27017");
sh.addShard("shard2/shard2:27017");

sh.enableSharding("somedb");
sh.shardCollection("somedb.helloDoc", { "name" : "hashed" });

use somedb;

for(var i = 0; i < 1000; i++) db.helloDoc.insertOne({age:i, name:"ly"+i})

printjson(db.helloDoc.countDocuments());
EOF

docker compose exec -T shard1 mongosh --quiet <<EOF
use somedb;

printjson(db.helloDoc.countDocuments());
EOF

docker compose exec -T shard2 mongosh --quiet <<EOF
use somedb;

printjson(db.helloDoc.countDocuments());
EOF
