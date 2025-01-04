# pymongo-api + шардирование + репликация + кеширование

## Как запустить

Перейти в папку sharding-repl-cache

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

Если всё запустится, в браузере вы увидите ответ следующего вида:
```json
{
  "mongo_topology_type": "Sharded",
  "mongo_replicaset_name": null,
  "mongo_db": "somedb",
  "read_preference": "Primary()",
  "mongo_nodes": [
    [
      "mongos_router",
      27025]
  ],
  "mongo_primary_host": null,
  "mongo_secondary_hosts": [],
  "mongo_address": [
    "mongos_router",
    27025],
  "mongo_is_primary": true,
  "mongo_is_mongos": true,
  "collections": {
    "helloDoc": {
      "documents_count": 1000
    }
  },
  "shards": {
    "shard1": "shard1/shard1-primary:27018,shard1-secondary1:27019,shard1-secondary2:27020",
    "shard2": "shard2/shard2-primary:27021,shard2-secondary1:27022,shard2-secondary2:27023"
  },
  "cache_enabled": true,
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