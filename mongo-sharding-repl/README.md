# mongo-sharding

## Проект состоит из следующих контейнеров

configSrv       // конфигурационный сервер
shard1
shard2
mongos_router   // роутер
mongo-express   // отобразить UI базы в браузере
pymongo_api     // апишка к базе

## Как запустить

Запускаем

```shell
docker compose -p mongo-sharding up
```
Инициализируем configSrv, shard1, shard2
Добавляем шарды к mongos_router
Наполняем mongos_router тестовыми данными
Заполняем mongodb данными

## Проверяем через pymongo_api

Откройте в браузере http://localhost:8080
Посмотреть базу http://localhost:8080/helloDoc/users
