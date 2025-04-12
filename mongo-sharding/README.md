# Задание 1

Реализован вариант первой схемы:

Список команд для запуска проекта:

1. Выполнить команду для сборки и запуска контейнеров **docker compose**

```bash
docker compose up -d
```

2. Выполнить скрипт инициализации для config-серверов:

```bash
docker exec -it mongodb-config1 mongosh --port 27019 --eval '
  rs.initiate({
    _id: "rs-config",
    configsvr: true,
    members: [
      { _id: 0, host: "mongodb-config1:27019" },
      { _id: 1, host: "mongodb-config2:27019" },
      { _id: 2, host: "mongodb-config3:27019" }
    ]
  })
'
```

3. Проверить статус config-серверов (можно выполнить на любом config-сервере)
```bash
docker exec -it mongodb-config1 mongosh --port 27019 --eval 'rs.status()'
```

Результат должен соответствовать следующему:


4. Выполнить скрипт иициализации для шардов
4.1 Для первого шарда (Шард 1):
```bash
docker exec -it mongodb-shard1 mongosh --port 27018 --eval 'rs.initiate({ _id: "rs-shard1", members: [{ _id: 0, host: "mongodb-shard1:27018" }] })'
```

4.2 Для второго шарда (Шард 2):
```bash
docker exec -it mongodb-shard2 mongosh --port 27018 --eval 'rs.initiate({ _id: "rs-shard2", members: [{ _id: 0, host: "mongodb-shard2:27018" }] })'
```

5. Выполнить скрипт по добавлению шардов через роутер
```bash
docker exec -it mongodb-router1 mongosh --eval '
  sh.addShard("rs-shard1/mongodb-shard1:27018");
  sh.addShard("rs-shard2/mongodb-shard2:27018")
'
```

6. Проверить, что оба роутера видят шарды

6.1 Для mongodb-router1
```bash
docker exec -it mongodb-router1 mongosh --eval 'sh.status()'
```
6.2 Для mongodb-router2
```bash
docker exec -it mongodb-router2 mongosh --eval 'sh.status()'
```


7. Наполнить БД тестовыми данными:
```bash
docker exec -it mongodb-router1 mongosh

> sh.enableSharding("somedb");
> sh.shardCollection("somedb.helloDoc", { "name" : "hashed" } )

> use somedb

> for(var i = 0; i < 1000; i++) db.helloDoc.insert({age:i, name:"ly"+i})

> db.helloDoc.countDocuments()
> exit();
```

Получится результат — 1000 документов.

8. Проверить кол-во документов на каждом из шардов
8.1 На первом шарде

```bash
docker exec -it mongodb-shard1 mongosh --port 27018

> use somedb;
> db.helloDoc.countDocuments();
> exit();
```

Получится результат — 492 документа.

8.2 На втором шарде

```bash
docker exec -it mongodb-shard2 mongosh --port 27018

> use somedb;
> db.helloDoc.countDocuments();
> exit();
```

Получится результат — 508 документа.
