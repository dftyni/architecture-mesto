#!/bin/bash

###
# Инициализируем бд
###
set -ex  # -e: остановка при ошибке, -x: вывод всех команд

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
quit();
EOF

docker compose exec -T shard1-1 mongosh --port 27018 <<EOF

rs.initiate(
    {
      _id : "shard1ReplSet",
      members: [
        { _id : 0, host : "shard1-1:27018" },
        { _id : 1, host : "shard1-2:27018" },
        { _id : 2, host : "shard1-3:27018" }
      ]
    }
);
quit();
EOF

docker compose exec -T shard2-1 mongosh --port 27019 <<EOF

rs.initiate(
    {
      _id: 'shard2ReplSet',
      members: [
        { _id: 0, host: 'shard2-1:27019' },
        { _id: 1, host: 'shard2-2:27019' },
        { _id: 2, host: 'shard2-3:27019' }
      ]
    }
  );
quit(); 
EOF

docker compose exec -T mongos_router mongosh --port 27020 <<EOF

sh.addShard('shard1ReplSet/shard1-1:27018,shard1-2:27018,shard1-3:27018');
sh.addShard('shard2ReplSet/shard2-1:27019,shard2-2:27019,shard2-3:27019');

sh.enableSharding("somedb");
db.helloDoc.drop();
sh.shardCollection("somedb.helloDoc", { "name" : "hashed" } )

use somedb;

for(var i = 0; i < 1000; i++) db.helloDoc.insert({age:i, name:"ly"+i})

db.helloDoc.countDocuments();
quit(); 
EOF