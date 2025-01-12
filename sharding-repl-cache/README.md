# pymongo-api

Приложение рассчитано на использование redis в single node режиме.

## Как запустить

Запускаем mongodb, redis и приложение.

```shell
docker compose up -d
```

Конфигурируем mongodb и заполняем базу тестовыми данными.

```shell
./scripts/sharding-repl-cache-init.sh
```

## Как проверить

Проверяем общее количество документов в базе и на каждом шарде.

```shell
./scripts/sharding-repl-cache-show-count.sh
```

Проверяем в браузере http://localhost:8080, должны увидеть json с информацией о mongodb.

Проверяем работу кеша в браузере http://localhost:8080/helloDoc/users, первый запрос выполняется примерно секунду, повторный запрос должен выполнятся примерно за 50 миллисекунд.

## Доступные эндпоинты

Список доступных эндпоинтов http://localhost:8080/docs.
