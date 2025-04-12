1. Инициализировать replica set для config сервера:
```
docker exec -it mongodb-config mongosh --port 27019 --eval 'rs.initiate({_id: "rs-config", configsvr: true, members: [{_id: 0, host: "mongodb-config:27019"}]})'
```

2. Инициализировать replica set для каждого шарда:
```
# Для shard1
docker exec -it mongodb-shard1 mongosh --port 27018 --eval 'rs.initiate({_id: "rs-shard1", members: [{_id: 0, host: "mongodb-shard1:27018"}]})'

# Для shard2
docker exec -it mongodb-shard2 mongosh --port 27018 --eval 'rs.initiate({_id: "rs-shard2", members: [{_id: 0, host: "mongodb-shard2:27018"}]})'
```

3. Добавить шарды через mongos:
```
docker exec -it mongodb-router mongosh --eval 'sh.addShard("rs-shard1/mongodb-shard1:27018")'
docker exec -it mongodb-router mongosh --eval 'sh.addShard("rs-shard2/mongodb-shard2:27018")'
```

4. Проверить, всё ли настроилось корректно

# Подключиться к mongos (роутеру)
docker exec -it mongodb-router mongosh

# Проверить статус шардов
sh.status()

# Проверить config сервер
use config
db.shards.find()


5. Наполнить тестовыми данными

# Подключиться к mongos (роутеру)
docker exec -it mongodb-router mongosh

# Наполнить данными
> sh.enableSharding("somedb"); # Включает шардинг для указанной базы данных (somedb).

> sh.shardCollection("somedb.helloDoc", { "name" : "hashed" } ) # Включает шардинг для коллекции helloDoc в БД somedb, используя хэшированный шард-ключ по полю name

> use somedb

> for(var i = 0; i < 1000; i++) db.helloDoc.insert({age:i, name:"ly"+i})

> db.helloDoc.countDocuments()
> exit();
