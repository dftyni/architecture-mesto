# Задание 2. Шардирование

## Как запустить

Запуск mongodb и приложения

```shell
docker compose up -d
```
Настройка сервера конфигураций, роутера и шардов. 
Заполнение mongodb данными: в коллекцию helloDoc будет записано 1000 документов

```shell
./scripts/mongo-init.sh
```

Проверка роутера
```shell
docker compose exec -T mongos_router mongosh --port 27020 <<EOF
use somedb
db.helloDoc.remove({});
for(var i = 0; i < 1000; i++) db.helloDoc.insertOne({age:i, name:"ly"+i})
db.helloDoc.countDocuments();
EOF
```

Проверка первого шарда
```shell
docker compose exec -T shard1 mongosh --port 27018 <<EOF
use somedb
db.helloDoc.countDocuments();
EOF
```

Проверка второго шарда
```shell
docker compose exec -T shard2 mongosh --port 27019 <<EOF
use somedb
db.helloDoc.countDocuments();
EOF
```

Проверка через бразуер.
При открытии 
http://<ip виртуальной машины>:8080/
должна отобразиться следующая информация:
```
{
  "mongo_topology_type": "Sharded",
  "mongo_replicaset_name": null,
  "mongo_db": "somedb",
  "read_preference": "Primary()",
  "mongo_nodes": [
    [
      "mongos_router",
      27020]
  ],
  "mongo_primary_host": null,
  "mongo_secondary_hosts": [],
  "mongo_address": [
    "mongos_router",
    27020],
  "mongo_is_primary": true,
  "mongo_is_mongos": true,
  "collections": {
    "helloDoc": {
      "documents_count": 1000
    }
  },
  "shards": {
    "shard1": "shard1/shard1:27018",
    "shard2": "shard2/shard2:27019"
  },
  "cache_enabled": false,
  "status": "OK"
}
```

