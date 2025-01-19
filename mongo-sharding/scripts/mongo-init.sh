#!/bin/bash

DOCKER_COMPOSE=docker-compose

# Функция ожидания, пока репликационный набор не станет PRIMARY
wait_for_primary() {
  local service_name="$1"  # имя сервиса в docker-compose (configsvr, shard1, shard2)
  local port="$2"          # порт MongoDB (27019, 27018, 27017)

  while true
  do
    # Получаем myState из rs.status()
    my_state=$($DOCKER_COMPOSE exec -T "$service_name" mongosh --quiet --port "$port" --eval 'rs.status().myState')
    
    if [ "$my_state" = "1" ]; then
      echo "Сервис $service_name (порт $port) стал PRIMARY!"
      break
    fi
    
    echo "Ожидаем, пока $service_name (порт $port) станет PRIMARY... Текущее myState=$my_state"
    sleep 5
  done
}

$DOCKER_COMPOSE up -d

# Настройка Config Server
$DOCKER_COMPOSE exec -T configsvr mongosh --host configsvr --port 27019 --quiet <<EOF
rs.initiate({
  _id: "configReplSet",
  configsvr: true,
  members: [{ _id: 0, host: "configsvr:27019" }]
})
EOF

# Настройка Shard 1
$DOCKER_COMPOSE exec -T shard1 mongosh --host shard1 --port 27018 --quiet <<EOF
rs.initiate({
  _id: "shard1ReplSet",
  members: [{ _id: 0, host: "shard1:27018" }]
})
EOF

# Настройка Shard 2
$DOCKER_COMPOSE exec -T shard2 mongosh --host shard2 --port 27017 --quiet <<EOF
rs.initiate({
  _id: "shard2ReplSet",
  members: [{ _id: 0, host: "shard2:27017" }]
})
EOF

wait_for_primary configsvr 27019
wait_for_primary shard1 27018
wait_for_primary shard2 27017

# Check status
$DOCKER_COMPOSE exec -T configsvr mongosh --host configsvr --port 27019 --quiet <<EOF
rs.status()
EOF

# Check status
$DOCKER_COMPOSE exec -T shard1 mongosh --host shard1 --port 27018 --quiet <<EOF
rs.status()
EOF

# Check status
$DOCKER_COMPOSE exec -T shard2 mongosh --host shard2 --port 27017 --quiet <<EOF
rs.status()
EOF

# Add shards via mongoshardard
$DOCKER_COMPOSE exec -T mongoshard mongosh --host mongoshard --port 27016 --quiet <<EOF
sh.addShard("shard1ReplSet/shard1:27018")
sh.addShard("shard2ReplSet/shard2:27017")
EOF

# Turn on sharding for db and collection
$DOCKER_COMPOSE exec -T mongoshard mongosh --host mongoshard --port 27016 --quiet <<EOF
sh.enableSharding("somedb")
db.helloDoc.createIndex({ shardKey: 1 })
sh.shardCollection("somedb.helloDoc", { age: "hashed" })
EOF

# Check sharding status 
$DOCKER_COMPOSE exec -T mongoshard mongosh --port 27016 --quiet <<EOF
sh.status()
EOF

echo "Filling with  docs..."
$DOCKER_COMPOSE  exec -T mongoshard mongosh --port 27016 <<EOF
use somedb
for(var i = 0; i < 15000; i++) db.helloDoc.insertOne({age:i, name:"ly"+i})
EOF
echo "Filling with  docs finished."
# All documents
$DOCKER_COMPOSE exec -T mongoshard mongosh --host mongoshard --port 27016 --quiet <<EOF
use somedb
db.helloDoc.countDocuments()
EOF

# Shards stat
$DOCKER_COMPOSE exec -T mongoshard mongosh --host mongoshard --port 27016 --quiet <<EOF
use somedb
var stats = db.helloDoc.stats();
function printCount(shardName) {
  if (stats.shards && stats.shards[shardName]) {
    print(shardName + ": " + stats.shards[shardName].count);
  } else {
    print(shardName + ": 0");
  }
}
printCount("shard1ReplSet");
printCount("shard2ReplSet");
EOF


