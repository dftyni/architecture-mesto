проект: mongo-sharding

# pymongo-api

## Как запустить

Запускаем приложение и инстансы mongoDB (сервер конфигурации, роутер, первый шард, второй шард)
```shell
docker compose up -d
```
Инициируем сервер конфигурации
```shell
./scripts/mongo-init-configSrv.sh
```
Инициируем 1-й шард
```shell
./scripts/mongo-init-shard1.sh
```
Инициируем 2-й шард
```shell
./scripts/mongo-init-shard2.sh
```
Инициируем роутер
```shell
./scripts/mongo-init-mongos_router.sh
```
Загружаем данные в роутер
```shell
./scripts/mongo-data-mongos_router.sh
```

## Как проверить

### проверка работы pymongo-api

Откройте в браузере http://localhost:8080
Если не запустился, остановите контейнер pymongo-api в docker desktop и снова запукстите 

### проверка документов в роутере и шардах

Проверяем загрузку данных на роутере
```shell
./scripts/mongo-doc-mongos_router.sh
```
Проверяем, сколько документов на первом шарде
```shell
./scripts/mongo-doc-shard1.sh
```
Проверяем, сколько документов на втором шарде
```shell
./scripts/mongo-doc-shard2.sh
```
## Доступные эндпоинты

Список доступных эндпоинтов, swagger http://localhost:8080/docs
