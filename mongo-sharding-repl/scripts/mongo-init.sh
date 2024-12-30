#!/bin/bash

# Подключаемся к серверу конфигурации и проводим инициализацию
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

exit();
EOF

sleep 1

# Инициализируем шард №1 с набором реплик
docker compose exec -T shard1-node1 mongosh --port 27018 <<EOF
rs.initiate(
    {
      _id : "shard1",
      members: [
        { _id : 0, host : "shard1-node1:27018" },
        { _id : 1, host : "shard1-node2:27018" },
        { _id : 2, host : "shard1-node3:27018" }
      ]
    }
);

exit();
EOF

sleep 1

# Инициализируем шард №2 с набором реплик
docker compose exec -T shard2-node1 mongosh --port 27019 <<EOF
rs.initiate(
    {
      _id : "shard2",
      members: [
        { _id : 3, host : "shard2-node1:27019" },
        { _id : 4, host : "shard2-node2:27019" },
        { _id : 5, host : "shard2-node3:27019" }
      ]
    }
);

exit();
EOF

sleep 1

# Инициализируем роутер и наполняем его тестовыми данными
docker compose exec -T mongos_router mongosh --port 27020 <<EOF
sh.addShard( "shard1/shard1-node1:27018,shard1-node2:27018,shard1-node3:27018");
sh.addShard( "shard2/shard2-node1:27019,shard2-node2:27019,shard2-node3:27019");

sh.enableSharding("somedb");
sh.shardCollection("somedb.helloDoc", { "name" : "hashed" } );

use somedb;

for(var i = 0; i < 1000; i++) db.helloDoc.insert({age:i, name:"ly"+i});

db.helloDoc.countDocuments();
exit();
EOF