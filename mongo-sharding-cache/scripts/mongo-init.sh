#!/bin/bash

docker exec -it configSrv mongosh --port 27017 --eval '
  rs.initiate({
    _id: "config_server",
    configsvr: true,
    members: [
      { _id: 0, host: "configSrv:27017" }
    ]
  });
'
docker exec -it configSrv2 mongosh --port 27027 --eval '
  rs.initiate({
    _id: "config_server",
    configsvr: true,
    members: [
      { _id: 0, host: "configSrv2:27027" }
    ]
  });
'

docker exec -it shard1 mongosh --port 27018 --eval '
  rs.initiate({
    _id: "shard1",
    members: [
      { _id: 0, host: "shard1:27018" },
      { _id: 1, host: "shard1_slave1:27028" },
      { _id: 2, host: "shard1_slave2:27038" },
      { _id: 3, host: "shard1_slave3:27048" }
    ]
  });
'


docker exec -it shard2 mongosh --port 27019 --eval '
  rs.initiate({
    _id: "shard2",
    members: [
      { _id: 0, host: "shard2:27019" },
      { _id: 1, host: "shard2_slave1:27029" },
      { _id: 2, host: "shard2_slave2:27039" },
      { _id: 3, host: "shard2_slave3:27049" }
    ]
  });
'

docker exec -it mongos_router mongosh --port 27020 --eval '

    sh.addShard("shard1/shard1:27018");
    sh.addShard("shard2/shard2:27019");
    
    sh.enableSharding("somedb");
    sh.shardCollection("somedb.helloDoc", { "name": "hashed" });
    
    for (var i = 0; i < 1000; i++) {
        db.getSiblingDB("somedb").helloDoc.insertOne({ age: i, name: "ly" + i });
      }
    
    print("Total documents in helloDoc collection:", db.getSiblingDB("somedb").helloDoc.countDocuments());
    
    print("Shard distribution for helloDoc collection:");
    printjson(db.getSiblingDB("somedb").helloDoc.getShardDistribution());
    exit();
'

docker exec -it mongos_router2 mongosh --port 27021 --eval '
    sh.addShard("shard1/shard1:27018");
    sh.addShard("shard2/shard2:27019");
    
    sh.enableSharding("somedb");
    sh.shardCollection("somedb.helloDoc", { "name": "hashed" });
    
    for (var i = 1000; i < 2000; i++) {
        db.getSiblingDB("somedb").helloDoc.insertOne({ age: i, name: "ly" + i });
    }
    print("Total documents in helloDoc collection:", db.getSiblingDB("somedb").helloDoc.countDocuments());
    
    print("Shard distribution for helloDoc collection:");
    printjson(db.getSiblingDB("somedb").helloDoc.getShardDistribution());
    exit();
'
echo "MongoDB Sharded Cluster Setup Complete!"