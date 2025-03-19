#!/bin/bash

# Инициируем роутер и наполняем данными базу для репликации

docker exec -it mongos_router mongosh --port 27020

> sh.addShard( "shard1/shard1-r1:27021", "shard1/shard1-r2:27022", "shard1/shard1-r3:27023");
> sh.addShard( "shard2/shard2-r1:27031", "shard2/shard2-r2:27032", "shard2/shard2-r3:27033");

> sh.enableSharding("somedb");
> sh.shardCollection("somedb.helloDoc", { "name" : "hashed" } )

> use somedb
> for(var i = 0; i < 1000; i++) db.helloDoc.insertOne({age:i, name:"ly"+i})

> db.helloDoc.countDocuments(); 
> exit();
