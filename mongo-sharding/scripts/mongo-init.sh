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
  rs.initiate(
      {
        _id : "shard1",
        members: [
          { _id : 0, host : "shard1:27018" },
        ]
      }
  );
EOF

###
# Инициализация шарда 2
###

docker compose exec -T shard2 mongosh --port 27019 <<EOF
  rs.initiate(
      {
        _id : "shard2",
        members: [
          { _id : 1, host : "shard2:27019" }
        ]
      }
  );
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
# Проверка данных на шарде 2
###

docker compose exec -T shard2 mongosh --port 27019 <<EOF
  use somedb
  db.helloDoc.countDocuments()
EOF