#!/bin/bash

# Инициализируем сервер конфигурации

docker exec -i configSrv mongosh --port 27017 <<EOF
rs.initiate({
  _id : "configSrv",
  configsvr: true,
  members: [
    { _id : 0, host : "configSrv:27017" }
  ]
});
exit();
EOF

sleep 2

# Инициализируем шард 1

docker exec -i shard1 mongosh --port 27018 <<EOF
rs.initiate({
  _id : "shard1",
  members: [
    { _id : 0, host : "shard1:27018" }
  ]
});
exit();
EOF

# Инициализируем шард 2

docker exec -i shard2 mongosh --port 27019 <<EOF
rs.initiate({
  _id : "shard2",
  members: [
    { _id : 0, host : "shard2:27019" }
  ]
});
exit();
EOF

sleep 2

# Инициализируем роутер и наполняем базу тестовыми данными

docker exec -i mongosRouter mongosh --port 27020 <<EOF
sh.addShard("shard1/shard1:27018");
sh.addShard("shard2/shard2:27019");
sh.enableSharding("somedb");
sh.shardCollection("somedb.helloDoc", { "name" : "hashed" });
use somedb;
for(var i = 0; i < 2000; i++) db.helloDoc.insertOne({age:i, name:"ly"+i});
db.helloDoc.countDocuments();
exit();
EOF
