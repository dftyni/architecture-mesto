# Проект Спринта 2 (шардирование и репликация)

## Перед тем, как начать

0. Перед тем, как начать, убедитесь, что старые контейнеры и тома удалены, чтобы избежать конфликтов с портами и сетями:

```bash
docker-compose down
docker rm -f $(docker ps -aq)
docker volume prune -f
docker network prune -f
```

А ещё могут остаться сарые даннве в бд. Если хочется, чтобы все прям было чисто и красиво, можно их тоже дропнуть:

```bash 
docker-compose exec -T shard1-1 mongosh --port 27018 --quiet <<EOF
use somedb;
db.helloDoc.drop();
EOF
```
```bash 
docker-compose exec -T shard2-1 mongosh --port 27019 --quiet <<EOF
use somedb;
db.helloDoc.drop();
EOF
```

## Настройка и запуск контейнеров

1. Перейдите в директорию проекта:

```bash
cd mongo-sharding
```

2. Запустите контейнеры: 

```bash
docker-compose up --build -d 
```
> **_NOTE:_**  используем -d, потому что иначе нам до инициализации завалит логами всё, жалуясь, что мы не инициализировали ничего. 

## Шардирование 

3. Инициализация configSrv

```bash
docker-compose exec -T configSrv mongosh --port 27017 --quiet <<EOF
rs.initiate({
  _id: "config_server",
  configsvr: true,
  members: [{ _id: 0, host: "configSrv:27017" }]
})
EOF
```
> **_NOTE:_**  используем -T чтобы он не плакал про "the input device is not a TTY"

4. Инициализация shard1

```bash
docker-compose exec -T shard1 mongosh --port 27018 --quiet <<EOF
rs.initiate({
  _id: "shard1",
  members: [{ _id: 0, host: "shard1:27018" }]
})
EOF
```

5. Инициализация shard2

```bash
docker-compose exec -T shard2 mongosh --port 27019 --quiet <<EOF
rs.initiate({
  _id: "shard2",
  members: [{ _id: 0, host: "shard2:27019" }]
})
EOF
```

6. Добавление шардов в роутер

```bash
docker-compose exec -T mongos_router mongosh --port 27020 --quiet <<EOF
sh.addShard("shard1/shard1:27018");
sh.addShard("shard2/shard2:27019");
EOF
```

7. Включение шардирования коллекции

```bash
docker-compose exec -T mongos_router mongosh --port 27020 --quiet <<EOF
sh.enableSharding("somedb");
sh.shardCollection("somedb.helloDoc", { "name" : "hashed" });
EOF
```
## Заполнение тестовыми данными 

8. Заполнение тестовыми данными

```bash
docker-compose exec -T mongos_router mongosh --port 27020 --quiet <<EOF
use somedb;
for (var i = 0; i < 1000; i++) db.helloDoc.insert({ age: i, name: "ly" + i });
EOF
```

## Проверка результата (опционально)

9. Можно проверить, что все вставилось и работает: 
```bash
docker-compose exec -T mongos_router mongosh --port 27020 --quiet <<EOF
use somedb;
db.helloDoc.countDocuments();
EOF
```

10. Можно так же проверить, что все разложилось по шардам: 

для шарда 1:
```bash
docker-compose exec -T shard1 mongosh --port 27018 --quiet <<EOF
use somedb;
db.helloDoc.countDocuments();
EOF
```

для шарда 2:
```bash
docker-compose exec -T shard2 mongosh --port 27019 --quiet <<EOF
use somedb;
db.helloDoc.countDocuments();
EOF
```