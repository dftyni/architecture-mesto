## Как запустить

Запускаем mongodb и приложение

```shell
docker compose up -d
```

Инициализируем mongodb

```shell
./scripts/mongo-init.sh
```

Заполняем mongodb данными

```shell
./scripts/fullfill-mongo.sh
```

## Как проверить

### Если вы запускаете проект на локальной машине

Откройте в браузере http://localhost:8080

## Список необходимых команд
### Все они выполняются в скрипте fullfill-mongo.sh отдельнозапускать их не нужно.

1. Инициализация сервера конфигурации
```shell
docker compose exec -T configSrv mongosh --port 27017 --quiet <<EOF

rs.initiate(
  {
    _id : "config_server",
       configsvr: true,
    members: [
      { _id : 0, host : "configSrv:27017" }
    ]
  }
);
exit();
EOF
```
2. Инициализация первого шарда и его реплики
```shell
docker compose exec -T shard1 mongosh --port 27018 --quiet <<EOF

rs.initiate(
    {
      _id : "shard1",
      members: [
        { _id : 0, host : "shard1:27018" },
        { _id : 1, host : "shard1_replica1:27028" }
      ]
    }
);
exit();
EOF
```
3. Инициализация второго шарда и его реплики
```shell
docker compose exec -T shard2 mongosh --port 27019 --quiet <<EOF

rs.initiate(
    {
      _id : "shard2",
      members: [
        { _id : 2, host : "shard2:27019" },
        { _id : 3, host : "shard2_replica1:27029" }
      ]
    }
);
exit();
EOF
```
4. Инициализация роутера
```shell
docker compose exec -T mongos_router mongosh --port 27020 --quiet <<EOF

sh.addShard( "shard1/shard1:27018");
sh.addShard( "shard2/shard2:27019");

sh.enableSharding("somedb");
sh.shardCollection("somedb.helloDoc", { "name" : "hashed" } )
exit();
EOF
```

5. Проверка количества документов на 1 шарде
```shell
docker compose exec -T shard1 mongosh --port 27018 --quiet <<EOF
use somedb;
db.helloDoc.countDocuments();
exit();
EOF
```

6. Проверка количества документов на реплике 1 шарда
```shell
docker compose exec -T shard1_replica1 mongosh --port 27028 --quiet <<EOF
use somedb;
db.helloDoc.countDocuments();
exit();
EOF
```

7. Проверка количества документов на 2 шарде
```shell
docker compose exec -T shard2 mongosh --port 27019 --quiet <<EOF
use somedb;
db.helloDoc.countDocuments();
exit();
EOF
```

8. Проверка количества документов на реплике 2 шарда
```shell
docker compose exec -T shard2_replica1 mongosh --port 27029 --quiet <<EOF
use somedb;
db.helloDoc.countDocuments();
exit();
EOF
```