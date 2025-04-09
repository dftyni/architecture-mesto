#!/bin/bash

# Инициализация конфигурационного сервера в качестве реплики
docker compose exec -T configSrv mongosh --port 27017 <<EOF
rs.initiate(
  {
    _id : "config_server",
    configsvr: true,
    members: [
      { _id : 0, host : "configSrv:27017" }
    ]
  }
)
EOF

# Инициализация первого шарда в качестве реплики
docker compose exec -T shard1 mongosh --port 27018 <<EOF
rs.initiate(
  {
    _id : "shard1",
    members: [
      { _id : 0, host : "shard1:27018" }
    ]
  }
)
EOF

# Инициализация второго шарда в качестве реплики
docker compose exec -T shard2 mongosh --port 27019 <<EOF
rs.initiate(
  {
    _id : "shard2",
    members: [
      { _id : 0, host : "shard2:27019" }
    ]
  }
)
EOF

# Добавление шардов в кластер и включение шардинга для базы данных "somedb"
docker compose exec -T mongos_router mongosh --port 27020 <<EOF
sh.addShard("shard1/shard1:27018");
sh.addShard("shard2/shard2:27019");
sh.enableSharding("somedb");
sh.shardCollection("somedb.helloDoc", { "name" : "hashed" } );
EOF

# Вставка данных в коллекцию "helloDoc" базы данных "somedb" через mongos
docker compose exec -T mongos_router mongosh --port 27020 <<EOF
use somedb
for(var i = 0; i < 1000; i++) db.helloDoc.insert({age:i, name:"ly"+i})
db.helloDoc.countDocuments()
EOF

# Подсчет документов в коллекции "helloDoc" на первом шарде
docker compose exec -T shard1 mongosh --port 27018 <<EOF
use somedb
db.helloDoc.countDocuments()
EOF

# Подсчет документов в коллекции "helloDoc" на втором шарде
docker compose exec -T shard2 mongosh --port 27019 <<EOF
use somedb
db.helloDoc.countDocuments()
EOF
