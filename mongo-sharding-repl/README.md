# Проект Спринта 2: Шардирование и Репликация MongoDB

1. Запуск контейнеров: 

```bash
docker-compose up --build -d 
```

2. Инициализация Config Server

```bash
docker-compose exec -T configSrv mongosh --port 27017
```
```bash
rs.initiate({
  _id: "config_server",
  configsvr: true,
  members: [{ _id: 0, host: "configSrv:27017" }]
})
```

3. Инициализация Shard 1

```bash
docker-compose exec -T shard1 mongosh --port 27018
```
```bash
rs.initiate({
  _id : "shard1",
  members: [
    { _id : 0, host : "shard1-1:27018" },
    { _id : 1, host : "shard1-2:27018" },
    { _id : 2, host : "shard1-3:27018" }
  ]
})
```

4. Инициализация Shard 2

```bash
docker-compose exec -T shard2 mongosh --port 27019
```
```bash
rs.initiate({
  _id : "shard2",
  members: [
    { _id : 0, host : "shard2-1:27019" },
    { _id : 1, host : "shard2-2:27019" },
    { _id : 2, host : "shard2-3:27019" }
  ]
})
```

5. Добавление шардов в Mongo Router

```bash
docker-compose exec -T mongo_router mongosh --port 27020
```
```bash
sh.addShard("shard1/shard1-1:27018");
```
```bash
sh.addShard("shard2/shard2-1:27019");
```

6. Включение шардирования коллекции
```bash
docker-compose exec -T mongo_router mongosh --port 27020
```
```bash
db.helloDoc.createIndex({ "name": 1 });
sh.enableSharding("somedb");
sh.shardCollection("somedb.helloDoc", { "name" : "hashed" });
```

7. Заполнение коллекции тестовыми документами
```bash
docker-compose exec -T mongo_router mongosh --port 27020
```
```bash
use somedb;
for (var i = 0; i < 1000; i++) db.helloDoc.insert({ age: i, name: "name" + i });
```
