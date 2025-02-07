#!/bin/bash

echo "Инициализация configSrv"
# Подключимся к серверу конфигурации и проведём инициализацию:
docker compose exec -T configSrv mongosh --port 27017 <<EOF
rs.initiate(
  {
    _id : "config_server",
       configsvr: true,
    members: [
      { _id : 0, host : "configSrv:27017" }
    ]
  }
);
EOF
sleep 2

echo "Инициализируем shard 1"
# Инициализируем шарды:
docker compose exec -T shard1-n1 mongosh --port 27018 <<EOF
rs.initiate(
  {
    _id : "shard1",
    members: [
      { _id : 0, host : "shard1-n1:27018" },
      { _id : 1, host : "shard1-n2:27019" },
      { _id : 2, host : "shard1-n3:27021" }
    ]
  }
);
EOF
sleep 2

echo "Инициализируем shard 2"
docker compose exec -T shard2-n1 mongosh --port 27016 <<EOF
rs.initiate(
  {
    _id : "shard2",
    members: [
      { _id : 0, host : "shard2-n1:27016" },
      { _id : 1, host : "shard2-n2:27022" },
      { _id : 2, host : "shard2-n3:27023" }
    ]
  }
);
EOF
sleep 2

echo "Инцициализируем роутер и наполним его тестовыми данными"
# Инцициализируем роутер и наполним его тестовыми данными:
docker compose exec -T mongos_router mongosh --port 27020 <<EOF
sh.addShard("shard1/shard1-n1:27018,shard1-n2:27019,shard1-n3:27021");
sh.addShard("shard2/shard2-n1:27016,shard2-n2:27022,shard2-n3:27023");

sh.enableSharding("somedb");
sh.shardCollection("somedb.helloDoc", { "name" : "hashed" } )

use somedb
for(var i = 0; i < 1000; i++) db.helloDoc.insertOne({age:i, name:"ly"+i})
db.helloDoc.countDocuments()
EOF
echo "Finish"