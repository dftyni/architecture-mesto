#!/bin/bash
set -e

wait_for_service() {
  local host=$1
  local port=$2
  local retries=10
  local wait_time=5

  echo "Ожидаем готовности $host на порту $port..."
  while [[ $retries -gt 0 ]]; do
    if docker compose exec -T $host mongosh --port $port --quiet --eval "db.adminCommand('ping')" &> /dev/null; then
      echo "$host на порту $port доступен."
      return
    fi
    retries=$((retries-1))
    echo "Попытка подключения к $host на порту $port... (осталось $retries попыток)"
    sleep $wait_time
  done
  echo "Подключение к $host на порту $port не удалось после нескольких попыток."
  exit 1
}

initialize_replica_set() {
  local primary_host=$1
  local replica_set_id=$2
  local port=$3
  shift 3
  local members=("$@")

  wait_for_service $primary_host $port

  local membersJS
  for i in "${!members[@]}"; do
    membersJS="${membersJS}{ _id: $i, host: \"${members[$i]}\" },"
  done

  membersJS="[${membersJS%,}]"

  docker compose exec -T $primary_host mongosh --port $port --quiet <<EOF
rs.initiate({
  _id: "$replica_set_id",
  members: $membersJS
});
EOF
  echo "$replica_set_id инициализирован с узлами: ${members[*]}"
}

initialize_config_servers() {
  initialize_replica_set "configSrv1" "config_server" 27017 "configSrv1:27017" "configSrv2:27017" "configSrv3:27017"
}

initialize_shard() {
  local shard_id=$1
  local primary_host=$2
  local port=$3
  local replica_hosts=("$@")

  initialize_replica_set $primary_host $shard_id $port "${replica_hosts[@]:3}"
}

initialize_mongos_and_data() {
  wait_for_service "mongos_router" 27020

  docker compose exec -T mongos_router mongosh --port 27020 --quiet <<EOF
sh.addShard("shard1/shard1a:27018,shard1b:27018,shard1c:27018");
sh.addShard("shard2/shard2a:27019,shard2b:27019,shard2c:27019");
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

initialize_config_servers
initialize_shard "shard1" "shard1a" 27018 "shard1a:27018" "shard1b:27018" "shard1c:27018"
initialize_shard "shard2" "shard2a" 27019 "shard2a:27019" "shard2b:27019" "shard2c:27019"
initialize_mongos_and_data

count_documents_in_shard "shard1a" 27018
count_documents_in_shard "shard2a" 27019
