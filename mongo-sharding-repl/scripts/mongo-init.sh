#!/bin/bash

###
# Подключаемся к серверу конфигурации и делаем инициализацию
###
docker compose exec -T configSrv mongosh --port 27017 --quiet <<EOF
rs.initiate(
  {
    _id : "config_server",
       configsvr: true,
    members: [
      { _id : 0, host : "configSrv:27017" }
    ]
  }
);
exit();
EOF

###
# Инициализируем первый шард и его реплики
###
docker compose exec -T shard1-replica1 mongosh --port 27021 --quiet <<EOF
rs.initiate(
    {
      _id : "shard1",
      members: [
        { _id : 0, host : "shard1-replica1:27021" },
        { _id : 1, host : "shard1-replica2:27022" },
        { _id : 2, host : "shard1-replica3:27023" }
      ]
    }
);
exit();
EOF

###
# Инициализируем второй шард и его реплики
###
docker compose exec -T shard2-replica1 mongosh --port 27024 --quiet <<EOF
rs.initiate(
    {
      _id : "shard2",
      members: [
        { _id : 3, host : "shard2-replica1:27024" },
        { _id : 4, host : "shard2-replica2:27025" },
        { _id : 5, host : "shard2-replica3:27026" }
      ]
    }
  );
exit(); 
EOF

###
# Инцициализируем роутер
###
docker compose exec -T mongos_router mongosh --port 27020 --quiet <<EOF
sh.addShard( "shard1/shard1-replica1:27021");
sh.addShard( "shard2/shard2-replica1:27024");
exit(); 
EOF

###
# Наполняем роутер тестовыми данными
###
docker compose exec -T mongos_router mongosh --port 27020 --quiet <<EOF
sh.enableSharding("somedb");
sh.shardCollection("somedb.helloDoc", { "name" : "hashed" } )
use somedb
for(var i = 0; i < 1500; i++) db.helloDoc.insertOne({age:i, name:"ly"+i})
db.helloDoc.countDocuments() 
exit(); 
EOF