# pymongo-api

Приложение с шардированием и репликацией БД Mongo и кэшированием.

Схема приложения draw.io: [pymongo-api.drawio](pymongo-api.drawio)

## Как запустить

Переходим в директорию проекта

```shell
cd sharding-repl-cache
```

Запускаем mongodb и приложение

```shell
docker compose up -d
```

Заполняем mongodb данными

```shell
./scripts/mongo-init.sh
```

## Как проверить

Откройте в браузере http://localhost:8080

