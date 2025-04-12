#!/bin/bash

echo "1. Starting MongoDB cluster initialization..."

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

echo "3. Waiting 5 seconds for config servers to initialize..."
sleep 5

# 2. Инициализация шардов
echo "4. Initializing shard 1..."
docker exec -i mongodb-shard1 mongosh --port 27018 --quiet --eval <<EOF
rs.initiate({ _id: "rs-shard1", members: [{ _id: 0, host: "mongodb-shard1:27018" }] })
EOF

echo "5. Initializing shard 2..."
docker exec -i mongodb-shard2 mongosh --port 27018 --quiet --eval <<EOF
rs.initiate({ _id: "rs-shard2", members: [{ _id: 0, host: "mongodb-shard2:27018" }] })
EOF

echo "6. Waiting 5 seconds for shards to initialize..."
sleep 5

# 3. Добавление шардов через роутер
echo "7. Adding shards to cluster..."
docker exec -i mongodb-router1 mongosh --quiet --eval <<EOF
sh.addShard("rs-shard1/mongodb-shard1:27018");
sh.addShard("rs-shard2/mongodb-shard2:27018")
EOF

# 4. Настройка шардинга для базы данных
echo "8. Configuring sharding for database..."
docker exec -i mongodb-router1 mongosh --quiet --eval <<EOF
sh.enableSharding("somedb");
sh.shardCollection("somedb.helloDoc", { "name" : "hashed" });
use somedb;
for(var i = 0; i < 1000; i++) db.helloDoc.insert({age:i, name:"ly"+i});
db.helloDoc.countDocuments();
EOF

echo "9. Waiting 5 seconds for data distribution..."
sleep 5

# 5. Проверка распределения данных по шардам
echo "10. Checking document distribution across shards..."

echo "11. Documents on shard1 (rs-shard1):"
docker exec -i mongodb-shard1 mongosh --port 27018 --quiet --eval <<EOF
use somedb;
db.helloDoc.countDocuments();
EOF

echo "12. Documents on shard2 (rs-shard2):"
docker exec -i mongodb-shard2 mongosh --port 27018 --quiet --eval <<EOF
use somedb;
db.helloDoc.countDocuments();
EOF

echo "13. MongoDB cluster initialization completed!"
echo "14. Test data has been inserted into somedb.helloDoc collection"
