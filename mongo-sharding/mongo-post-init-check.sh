#!/bin/bash

# Проверка количества реплик для shard01
echo ">>> Проверка количества реплик для shard01"
docker exec shard-01-node-a mongosh --quiet --eval '
print("Shard01 реплики:");
rs.status().members.forEach(member => {
    print(member.name + " - " + member.stateStr);
});
'

# Проверка количества реплик для shard02
echo ">>> Проверка количества реплик для shard02"
docker exec shard-02-node-a mongosh --quiet --eval '
print("Shard02 реплики:");
rs.status().members.forEach(member => {
    print(member.name + " - " + member.stateStr);
});
'

# Проверка общего количества документов в базе
echo ">>> Проверка общего количества документов в базе"
docker exec -i router-01 mongosh --quiet <<EOF
use somedb;
const count = db.helloDoc.countDocuments();
print("Общее количество документов в базе: " + count);
EOF
