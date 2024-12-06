#!/bin/bash

###
# Инициализируем бд
###

docker compose exec -T configSrv mongosh --port 27017  --quiet <<EOF
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

docker compose exec -T shard1 mongosh --port 27018 --quiet  <<EOF
rs.initiate(
    {
      _id: "shard1",
      members: [
        { _id: 0, host : "shard1:27018" },
        { _id: 1, host: "s1mongodb1:27027" },
        { _id: 2, host: "s1mongodb2:27028" }
      ]
    }
);
EOF

#docker compose exec -T redis_1  <<EOF
#echo "Resid 1 as a cluster" |
#redis-cli --cluster create   173.17.0.30:6379   173.17.0.31:6379  --cluster-replicas 1
#EOF

docker compose exec -T shard2 mongosh --port 27019 --quiet <<EOF
\'shard2\'
rs.initiate(
    {
      _id: "shard2",
      members: [
        { _id: 1, host : "shard2:27019" },
        { _id: 2, host: "s2mongodb1:27037" },
        { _id: 3, host: "s2mongodb2:27038" }
      ]
    }
  );
EOF

docker compose exec -T mongos_router mongosh --port 27020 --quiet  <<EOF
sh.addShard( "shard1/shard1:27018");
sh.addShard( "shard2/shard2:27019");

sh.enableSharding("somedb");
sh.shardCollection("somedb.helloDoc", { "name" : "hashed" } )
EOF

docker compose exec -T mongos_router mongosh --port 27020 --quiet <<EOF
\'Start fill database\'
use somedb
for(var i = 0; i < 1000; i++) db.helloDoc.insertOne({age:i, name:"ly"+i})
EOF

