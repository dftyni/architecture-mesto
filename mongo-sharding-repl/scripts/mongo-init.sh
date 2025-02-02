#!/bin/bash

###
# Инициализация сервера конфигурации
###

docker compose exec -T mongo_config_server mongosh --port 27017 <<EOF
  rs.initiate(
    {
      _id : "config_server",
      configsvr: true,
      members: [
        { _id : 0, host : "mongo_config_server:27017" }
      ]
    }
  );
EOF

###
# Инициализация шарда 1
###

docker compose exec -T shard1 mongosh --port 27018 <<EOF
  rs.initiate({
    _id: "shard1",
    members: [
      {_id: 0, host: "shard1:27018"},
      {_id: 1, host: "shard1_0:27021"},
      {_id: 2, host: "shard1_1:27022"}
    ]
  });
EOF

###
# Инициализация шарда 2
###

docker compose exec -T shard2 mongosh --port 27019 <<EOF
  rs.initiate({
    _id: "shard2",
    members: [
      {_id: 0, host: "shard2:27019"},
      {_id: 1, host: "shard2_0:27023"},
      {_id: 2, host: "shard2_1:27024"}
    ]
  });
EOF

###
# Инициализация роутера и наполнение его тестовыми данными
###

docker compose exec -T mongos_router mongosh --port 27020 <<EOF
  sh.addShard("shard1/shard1:27018");
  sh.addShard("shard2/shard2:27019");

  sh.enableSharding("somedb");

  sh.shardCollection("somedb.helloDoc", { "name" : "hashed" } )

  use somedb

  var values = [];
  for (var i = 0; i < 1000; i++) {
    values.push({ age: i, name: "ly" + i });
  }
  db.helloDoc.insertMany(values);
EOF

###
# Проверка данных на шарде 1
###

docker compose exec -T shard1 mongosh --port 27018 <<EOF
  use somedb

  db.helloDoc.countDocuments()
EOF

###
# Проверка данных на реплике 1 шарда 1
###

docker compose exec -T shard1_0 mongosh --port 27021 <<EOF
  rs.status()
  rs.secondaryOk()

  use somedb

  db.helloDoc.find().count()
EOF

###
# Проверка данных на реплике 2 шарда 1
###

docker compose exec -T shard1_1 mongosh --port 27022 <<EOF
  rs.status()
  rs.secondaryOk()

  use somedb

  db.helloDoc.find().count()
EOF

###
# Проверка данных на втором шарде
###

docker compose exec -T shard2 mongosh --port 27019 <<EOF
  use somedb

  db.helloDoc.countDocuments()
EOF

###
# Проверка данных на реплике 1 шарда 2
###

docker compose exec -T shard2_0 mongosh --port 27023 <<EOF
  rs.status()
  rs.secondaryOk()

  use somedb

  db.helloDoc.find().count()
EOF

###
# Проверка данных на реплике 2 шарда 2
###

docker compose exec -T shard2_1 mongosh --port 27024 <<EOF
  rs.status()
  rs.secondaryOk()

  use somedb

  db.helloDoc.find().count()
EOF