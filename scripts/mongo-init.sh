#!/bin/bash


docker compose exec -T configSrv mongosh --port 27010 --quiet <<EOF
rs.initiate(
   {
    "_id" : "config_server",
        "configsvr": true,
     "members": [
       { "_id" : 0, "host" : "configSrv:27010" }
     ]
    }
);
EOF


docker compose exec -T shard1r0 mongosh --port 27020 --quiet <<EOF
rs.initiate(
    {
      _id : "shard1",
      members: [
        { _id : 0, host : "shard1r0:27020" },
        { _id : 1, host : "shard1r1:27021" },
        { _id : 2, host : "shard1r2:27022" }
      ]
    }
);
EOF


docker compose exec -T shard2r0 mongosh --port 27030 --quiet <<EOF
rs.initiate(
    {
      _id : "shard2",
      members: [
        { _id : 0, host : "shard2r0:27030" },
        { _id : 1, host : "shard2r1:27031" },
        { _id : 2, host : "shard2r2:27032" }
      ]
    }
  );
EOF

docker compose exec -T mongos_router mongosh --port 27011 --quiet <<EOF
sh.addShard( "shard1/shard1r0:27020,shard1r1:27021,shard1r2:27022");
sh.addShard( "shard2/shard2r0:27030,shard2r1:27031,shard2r2:27032");
sh.enableSharding("somedb");
sh.shardCollection("somedb.helloDoc", { "name" : "hashed" } );
use somedb;
for(var i = 0; i < 1000; i++) db.helloDoc.insertOne({age:i, name:"doc"+i});
db.helloDoc.countDocuments();
EOF

# check docs on first shard
docker compose exec -T shard1r0 mongosh --port 27020 --quiet <<EOF
use somedb;
db.helloDoc.countDocuments();
exit();
EOF
