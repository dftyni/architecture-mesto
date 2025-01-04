# pymongo-api

## Как запустить

Перейти в папку mongo-sharding

```shell
docker compose up -d
```

Чтобы настроить все сервисы необходимо запустить скрипт

```shell
./scripts/setup-all.sh
```

## Как проверить

### Если вы запускаете проект на локальной машине

Откройте в браузере http://localhost:8080

Если все запуститься, то в браузере вы увидел ответ вида:
```json
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
      "documents_count": 1492
    }
  },
  "shards": {
    "shard1": "shard1/shard1:27018"
  },
  "cache_enabled": false,
  "status": "OK"
}
```

### Если вы запускаете проект на предоставленной виртуальной машине

Узнать белый ip виртуальной машины

```shell
curl --silent http://ifconfig.me
```

Откройте в браузере http://<ip виртуальной машины>:8080

## Доступные эндпоинты

Список доступных эндпоинтов, swagger http://<ip виртуальной машины>:8080/docs