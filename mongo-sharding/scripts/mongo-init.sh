#!/bin/bash
set -e

initialize_replica_set() {
  local host=$1
  local port=$2
  local replica_set_id=$3

  docker compose exec -T $host mongosh --port $port --quiet <<EOF
rs.initiate(
    {
      _id : "$replica_set_id",
      members: [
        { _id : 0, host : "$host:$port" }
      ]
    }
);
EOF
  echo "$replica_set_id initialized on $host:$port."
}

initialize_config_server() {
  docker compose exec -T configSrv mongosh --port 27017 --quiet <<EOF
rs.initiate(
  {
    _id: "config_server",
    configsvr: true,
    members: [
      { _id: 0, host: "configSrv:27017" }
    ]
  }
);
EOF
  echo "Config server initialized."
}

initialize_mongos_and_data() {
  docker compose exec -T mongos_router mongosh --port 27020 --quiet <<EOF
sh.addShard("shard1/shard1:27018");
sh.addShard("shard2/shard2:27019");
sh.enableSharding("somedb");
sh.shardCollection("somedb.helloDoc", { "name" : "hashed" });
use somedb;
for (var i = 0; i < 1000; i++) {
  db.helloDoc.insert({age: i, name: "ly" + i});
}
print("Total documents in somedb: " + db.helloDoc.countDocuments());
EOF
  echo "Mongos router initialized and data populated."
}

count_documents_in_shard() {
  local shard_name=$1
  local port=$2

  echo "Number of documents in $shard_name:"
  docker compose exec -T $shard_name mongosh --port $port --quiet <<EOF
use somedb;
print("Documents in $shard_name: " + db.helloDoc.countDocuments());
EOF
}

initialize_config_server
initialize_replica_set "shard1" 27018 "shard1"
initialize_replica_set "shard2" 27019 "shard2"
initialize_mongos_and_data
count_documents_in_shard "shard1" 27018
count_documents_in_shard "shard2" 27019
