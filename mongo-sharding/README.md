# pymongo-api

## Как запустить

В папке mongo-sharding выполняем следующие команды:

```shell
docker compose -f ./compose.yaml up -d  
./scripts/mongo-init-config.sh
./scripts/mongo-init-shard-0.sh
./scripts/mongo-init-shard-1.sh
./scripts/mongo-init-router.sh
```

Заполняем mongodb данными

```shell
./scripts/mongo-init.sh
```

## Как проверить

### Если вы запускаете проект на локальной машине

Откройте в браузере http://localhost:8080

### Если вы запускаете проект на предоставленной виртуальной машине

Узнать белый ip виртуальной машины

```shell
curl --silent http://ifconfig.me
```

Откройте в браузере http://<ip виртуальной машины>:8080

## Доступные эндпоинты

Список доступных эндпоинтов, swagger http://<ip виртуальной машины>:8080/docs