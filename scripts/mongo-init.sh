#!/bin/bash

echo "Ожидание готовности контейнеров..."
until docker compose ps | grep -q "healthy"; do
  sleep 2
  echo "Ждём, пока все контейнеры будут готовы..."
done
echo "Все контейнеры запущены!"

echo "Инициализация сервера конфигурации..."
docker compose exec -T configSrv mongosh --port 27019 <<EOF
rs.initiate({
  _id: "config_server",
  members: [{ _id: 0, host: "configSrv:27019" }]
});
while (!rs.status().ok) { sleep(1000); }
EOF

echo "Инициализация шарда 1..."
docker compose exec -T shard1-db1 mongosh --port 27017 <<EOF
rs.initiate({
  _id: "shard1",
  members: [{ _id: 0, host: "shard1-db1:27017" }]
});
while (!rs.status().ok) { sleep(1000); }
EOF

echo "Инициализация шарда 2..."
docker compose exec -T shard2-db1 mongosh --port 27018 <<EOF
rs.initiate({
  _id: "shard2",
  members: [{ _id: 0, host: "shard2-db1:27018" }]
});
while (!rs.status().ok) { sleep(1000); }
EOF

echo "Добавление шардов в MongoS..."
docker compose exec -T mongos_router mongosh --port 27020 <<EOF
sh.addShard("shard1-db1:27017");
sh.addShard("shard2-db1:27018");
use somedb;
sh.enableSharding("somedb");
sh.shardCollection("somedb.helloDoc", {"name": "hashed"});
EOF

echo "Наполнение базы тестовыми данными..."
docker compose exec -T mongos_router mongosh --port 27020 <<EOF
use somedb;
for (var i = 0; i < 1000; i++) db.helloDoc.insertOne({age: i, name: "ly" + i});
print("Общее количество документов:", db.helloDoc.countDocuments());
EOF

echo "Вывод статуса шардинга..."
docker compose exec -T mongos_router mongosh --port 27020 <<EOF
db.printShardingStatus();
EOF

echo "Вывод количества документов в каждом шарде..."
docker compose exec -T shard1-db1 mongosh --port 27017 <<EOF
use somedb;
print("Документы в shard1:", db.helloDoc.countDocuments());
EOF

docker compose exec -T shard2-db1 mongosh --port 27018 <<EOF
use somedb;
print("Документы в shard2:", db.helloDoc.countDocuments());
EOF

echo "✅ Инициализация и проверка завершены!"
