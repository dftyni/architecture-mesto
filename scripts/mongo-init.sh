#!/bin/bash

# Инициируем сервер конфигурации
docker compose exec -T configSrv mongosh --port 27019 <<EOF
rs.initiate(
  {
    _id : "config_server",
    configsvr: true,
    members: [
      { _id : 0, host : "configSrv:27019" }
    ]
  }
);
EOF

# Инициируем шард 1
sleep 1
docker compose exec -T shard1-db1 mongosh <<EOF
rs.initiate(
  {
    _id : "shard1",
    members: [
      { _id : 0, host : "shard1-db1:27017" }
    ]
  }
);
EOF

# Инициируем шард 2
sleep 1
docker compose exec -T shard2-db1 mongosh <<EOF
rs.initiate(
  {
    _id : "shard2",
    members: [
      { _id : 0, host : "shard2-db1:27017" }
    ]
  }
);
EOF

# Инициируем роутер, наполняем базу тестовыми данными
sleep 1
docker compose exec -T mongos_router mongosh <<EOF
sh.addShard("shard1/shard1-db1:27017");
sh.addShard("shard2/shard2-db1:27017");
sh.enableSharding("somedb");
sh.shardCollection("somedb.helloDoc", {"name" : "hashed"});
use somedb;
for(var i = 0; i < 1000; i++) db.helloDoc.insertOne({age:i, name:"ly"+i});
db.helloDoc.countDocuments();
EOF

# Проверки (вывводим кол-во документов в каждом из шардов)
docker compose exec -T shard1-db1 mongosh <<EOF
use somedb;
db.helloDoc.countDocuments();
exit();
EOF

docker compose exec -T shard2-db1 mongosh <<EOF
use somedb;
db.helloDoc.countDocuments();
exit();
EOF
