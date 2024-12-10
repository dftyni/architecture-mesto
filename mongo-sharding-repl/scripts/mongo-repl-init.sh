#!/bin/bash

###
# Инициализация шардирования и заполнение данными
###

# Подключаемся к серверу конфигурации и проводим инициализацию:
docker compose exec -T configSrv mongosh --port 27019 --quiet <<EOF
use somedb

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

# Инициализируем реплицированные шарды:
docker compose exec -T shard1-1 mongosh --port 27022 --quiet <<EOF

rs.initiate(
    {
      _id : "shard1",
      members: [
        { _id : 0, host : "shard1-1:27022" },
        { _id : 1, host : "shard1-2:27023" },
        { _id : 2, host : "shard1-3:27024" },
      ]
    }
);
EOF

docker compose exec -T shard2-1 mongosh --port 27028 --quiet <<EOF

rs.initiate(
    {
      _id : "shard2",
      members: [
        { _id : 3, host : "shard2-1:27028" },
        { _id : 4, host : "shard2-2:27029" },
        { _id : 5, host : "shard2-3:27030" },
      ]
    }
  );
EOF

# Инициализируем роутер и наполняем его данными:
docker compose exec -T mongos_router mongosh --port 27017 --quiet <<EOF

sh.addShard( "shard1/shard1-1:27022");
sh.addShard( "shard2/shard2-1:27028");

sh.enableSharding("somedb");
sh.shardCollection("somedb.helloDoc", { "name" : "hashed" } )

use somedb

for(var i = 0; i < 1000; i++) db.helloDoc.insert({age:i, name:"ly"+i})

db.helloDoc.countDocuments() 
EOF