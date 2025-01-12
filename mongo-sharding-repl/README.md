# pymongo-api

## Как запустить

Запускаем mongodb и приложение.

```shell
docker compose up -d
```

Конфигурируем mongodb и заполняем тестовыми данными.

```shell
./scripts/mongo-sharding-repl-init.sh
```

## Как проверить

Проверяем общее количество документов в базе и на каждом шарде.

```shell
./scripts/mongo-sharding-repl-show-count.sh
```

Проверяем в браузере http://localhost:8080, должны увидеть json с информацией о mongodb.

## Доступные эндпоинты

Список доступных эндпоинтов http://localhost:8080/docs.
