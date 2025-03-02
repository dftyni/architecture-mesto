ссылка на схему (задания 2-6) в draw.io:
https://drive.google.com/file/d/1xnAF0VIiFMNml_-vosCpC3ChU_gG_Ng_/view?usp=sharing

name: sharding-repl-cache

# pymongo-api

## Как запустить

1  Запускаем приложение и инстансы mongoDB (сервер конфигурации, роутер, первый шард(3 хоста), второй шард(3 хоста) и редис)
```shell
docker compose up -d
```
2  Инициируем сервер конфигурации
```shell
./scripts/mongo-init-configSrv.sh
```
3  Инициируем 1-й шард, три ноды репликации
```shell
./scripts/mongo-init-shard1.sh
```
4  Инициируем 2-й шард, три ноды репликации
```shell
./scripts/mongo-init-shard2.sh
```
5  Инициируем роутер
```shell
./scripts/mongo-init-mongos_router.sh
```
6  Загружаем данные
```shell
./scripts/mongo-data-mongos_router.sh
```

## Как проверить

### проверка работы pymongo-api

7  Откройте в браузере http://localhost:8080
Если не запустился, остановите контейнер pymongo-api в docker desktop и снова запукстите 

### проверка документов в роутере и шардах

8  Проверяем загрузку данных на роутере
```shell
./scripts/mongo-doc-mongos_router.sh
```
9  Проверяем, сколько документов на первом шарде
```shell
./scripts/mongo-doc-shard1.sh
```
10  Проверяем, сколько документов на втором шарде
```shell
./scripts/mongo-doc-shard2.sh
```
## Доступные эндпоинты

Список доступных эндпоинтов, swagger http://localhost:8080/docs

Эндпоинт для проверки кеширования: http://localhost:8080/helloDoc/users


