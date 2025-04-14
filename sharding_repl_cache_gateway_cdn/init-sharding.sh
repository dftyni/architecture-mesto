#!/bin/bash

echo "============================"
echo "MONGODB SHARDING + REPLICATION INIT"
echo "============================"

docker compose exec -T configsvr mongosh --quiet --eval "rs.initiate({_id: 'cfgRS', configsvr: true, members: [{ _id: 0, host: 'configsvr:27017' }]})"

docker compose exec -T shard1-a mongosh --port 27018 --quiet --eval "rs.initiate({_id: 'shard1RS', members: [{ _id: 0, host: 'shard1-a:27018' }, { _id: 1, host: 'shard1-b:27019' }, { _id: 2, host: 'shard1-c:27020' }]})"
docker compose exec -T shard2-a mongosh --port 27021 --quiet --eval "rs.initiate({_id: 'shard2RS', members: [{ _id: 0, host: 'shard2-a:27021' }, { _id: 1, host: 'shard2-b:27022' }, { _id: 2, host: 'shard2-c:27023' }]})"

docker compose exec -T mongos mongosh --quiet --eval "
sh.addShard('shard1RS/shard1-a:27018');
sh.addShard('shard2RS/shard2-a:27021');
sh.enableSharding('somedb');
sh.shardCollection('somedb.helloDoc', { user_id: 1 });
db = db.getSiblingDB('somedb');
db.helloDoc.createIndex({ user_id: 1 });
sh.splitAt('somedb.helloDoc', { user_id: 500 });
for (let i = 1; i <= 1002; i++) {
  db.helloDoc.insertOne({ user_id: i, name: 'User ' + i });
}
"

docker cp init-data.js mongos:/init-data.js
docker compose exec -T mongos mongosh --file /init-data.js

echo
echo "Готово. Проверьте http://localhost:8080/helloDoc/users"
