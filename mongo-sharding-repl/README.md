# pymongo-api

## Как запустить

Запускаем mongodb и приложение

```shell
docker compose up -d
```

Заполняем mongodb данными

```shell
./scripts/mongo-init.sh
```
Удаляем БД

```shell
./scripts/db-drop.sh
```

## Как проверить

### Если вы запускаете проект на локальной машине

Проверям данные на шадрах и роутере

```shell
./scripts/mongo-count.sh
```

Можно увидеть, что на мастере и репликах одинаковое количество элементов
```shell
Total elements
1000

Shard1 count elements
492

Shard1 repl count
3

Shard1 repl-1 count elements
492

Shard1 repl-2 count elements
492

Shard2 count elements
508

Shard2 repl count
3

Shard2 repl-1 count elements
508 

Shard2 repl-2 count elements
508
```
Выведет количество элементов на шардах и количество инстаносв в репликасете: по 3 штуки на шард

Откройте в браузере http://localhost:8080, где можно увидеть все хосты шардов и реплик

## Доступные эндпоинты

Список доступных эндпоинтов, swagger http://<ip виртуальной машины>:8080/docs