#!/bin/bash

echo "1. Starting MongoDB cluster initialization..."

# Функция для проверки готовности MongoDB
wait_for_mongo() {
  local host=$1
  local port=$2
  local max_attempts=10
  local attempt=0
  local delay=2

  echo "Waiting for MongoDB at $host:$port to be ready..."

  until docker exec -i $host mongosh --port $port --quiet --eval "db.adminCommand({ping: 1})" > /dev/null 2>&1; do
    attempt=$((attempt + 1))
    if [ $attempt -ge $max_attempts ]; then
      echo "MongoDB at $host:$port not ready after $max_attempts attempts, exiting..."
      exit 1
    fi
    sleep $delay
  done

  echo "MongoDB at $host:$port is ready"
}

# Функция для проверки инициализации replica set
wait_for_rs_init() {
  local host=$1
  local port=$2
  local rs_name=$3
  local max_attempts=10
  local attempt=0
  local delay=2

  echo "Waiting for replica set $rs_name at $host:$port to initialize..."

  until docker exec -i $host mongosh --port $port --quiet --eval "rs.status().ok" | grep -q 1; do
    attempt=$((attempt + 1))
    if [ $attempt -ge $max_attempts ]; then
      echo "Replica set $rs_name at $host:$port not ready after $max_attempts attempts, exiting..."
      exit 1
    fi
    sleep $delay
  done

  until docker exec -i $host mongosh --port $port --quiet --eval "rs.status().members.every(m => m.stateStr === 'PRIMARY' || m.stateStr === 'SECONDARY')" | grep -q true; do
    attempt=$((attempt + 1))
    if [ $attempt -ge $max_attempts ]; then
      echo "Replica set $rs_name members not ready after $max_attempts attempts, exiting..."
      exit 1
    fi
    sleep $delay
  done

  echo "Replica set $rs_name at $host:$port is ready"
}

# 1. Инициализация config серверов
echo "2. Initializing config servers replica set..."
docker exec -i mongodb-config1 mongosh --port 27019 --quiet --eval <<EOF
rs.initiate({
  _id: "rs-config",
  configsvr: true,
  members: [
    { _id: 0, host: "mongodb-config1:27019" },
    { _id: 1, host: "mongodb-config2:27019" },
    { _id: 2, host: "mongodb-config3:27019" }
  ]
})
EOF

# Проверка готовности config серверов
wait_for_rs_init mongodb-config1 27019 "rs-config"

# 2. Инициализация шардов
echo "3. Initializing shard 1 replica set..."
docker exec -i mongodb-shard1-node1 mongosh --port 27018 --quiet --eval <<EOF
rs.initiate({
  _id: "rs-shard1",
  members: [
    { _id: 0, host: "mongodb-shard1-node1:27018" },
    { _id: 1, host: "mongodb-shard1-node2:27018", priority: 0.5 },
    { _id: 2, host: "mongodb-shard1-node3:27018", priority: 0.5 }
  ]
})
EOF

echo "4. Initializing shard 2 replica set..."
docker exec -i mongodb-shard2-node1 mongosh --port 27018 --quiet --eval <<EOF
rs.initiate({
  _id: "rs-shard2",
  members: [
    { _id: 0, host: "mongodb-shard2-node1:27018" },
    { _id: 1, host: "mongodb-shard2-node2:27018", priority: 0.5 },
    { _id: 2, host: "mongodb-shard2-node3:27018", priority: 0.5 }
  ]
})
EOF

# Проверка готовности шардов
wait_for_rs_init mongodb-shard1-node1 27018 "rs-shard1"
wait_for_rs_init mongodb-shard2-node1 27018 "rs-shard2"

# Проверка готовности роутеров
wait_for_mongo mongodb-router1 27017
wait_for_mongo mongodb-router2 27017

# 3. Добавление шардов через роутер
echo "5. Adding shards to cluster..."
docker exec -i mongodb-router1 mongosh --quiet --eval <<EOF
sh.addShard("rs-shard1/mongodb-shard1-node1:27018,mongodb-shard1-node2:27018,mongodb-shard1-node3:27018");
sh.addShard("rs-shard2/mongodb-shard2-node1:27018,mongodb-shard2-node2:27018,mongodb-shard2-node3:27018");
EOF

# 4. Настройка шардинга для базы данных
echo "6. Configuring sharding for database..."
docker exec -i mongodb-router1 mongosh --quiet --eval <<EOF
sh.enableSharding("somedb");
sh.shardCollection("somedb.helloDoc", { "name" : "hashed" });
use somedb;
for(var i = 0; i < 1000; i++) db.helloDoc.insert({age:i, name:"ly"+i});
db.helloDoc.countDocuments();
EOF

# Проверка распределения данных
echo "7. Checking document distribution across shards..."

echo "8. Documents on shard1 (rs-shard1):"
docker exec -i mongodb-shard1-node1 mongosh --port 27018 --quiet --eval <<EOF
use somedb;
db.helloDoc.countDocuments();
EOF

echo "9. Documents on shard2 (rs-shard2):"
docker exec -i mongodb-shard2-node1 mongosh --port 27018 --quiet --eval <<EOF
use somedb;
db.helloDoc.countDocuments();
EOF

echo "10. MongoDB cluster initialization completed!"
echo "11. Test data has been inserted into somedb.helloDoc collection"
