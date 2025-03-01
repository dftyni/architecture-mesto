# mongo-sharding

## Как запустить

1) Запускаем mongodb и приложение

```shell
docker compose up -d
```

2) Подключитесь к серверу конфигурации и сделайте инициализацию:

```shell
docker exec -it configSrv mongosh --port 27017

    > rs.initiate(
     {
      _id : "config_server",
        configsvr: true,
            members: [
              { _id : 0, host : "configSrv:27017" }
            ]
        }
      );
    > exit();
```

3) Инициализируйте шарды:

```shell
docker exec -it shard1 mongosh --port 27018

> rs.initiate(
    {
      _id : "shard1",
      members: [
        { _id : 0, host : "shard1:27018" }
      ]
    }
);
> exit();

docker exec -it shard2 mongosh --port 27019

> rs.initiate(
    {
      _id : "shard2",
      members: [
        { _id : 1, host : "shard2:27019" }
      ]
    }
  );
> exit();

```

4) Инцициализируйте роутер

```shell
docker exec -it mongos_router mongosh --port 27020

> sh.addShard( "shard1/shard1:27018");
> sh.addShard( "shard2/shard2:27019");
> exit();

```

5) Заполняем mongodb данными

```shell
docker exec -it mongos_router mongosh --port 27020

> sh.enableSharding("somedb");
> sh.shardCollection("somedb.helloDoc", { "name" : "hashed" } )

> use somedb

> for(var i = 0; i < 1000; i++) db.helloDoc.insert({age:i, name:"ly"+i})

> db.helloDoc.countDocuments() 
> exit();

```
После выполнения скрипта видим 1000 созданных документов. 

6) Сделаем проверку на шардах:

```shell

docker compose exec -T shard1 mongosh --port 27018 --quiet <<EOF
use somedb
db.helloDoc.countDocuments()
EOF
 
 ```
Получится результат — 492 документа.

```shell

docker compose exec -T shard2 mongosh --port 27019 --quiet <<EOF
use somedb
db.helloDoc.countDocuments()
EOF


```

Получится результат — 508 документов.

7) Откройте в браузере http://localhost:8080/docs

Выполните вызов GET API /{collection_name}/count, указав в качестве параметра collection_name значение helloDoc. 
Ответ приложения будет следующим:
```json
{
  "status": "OK",
  "mongo_db": "somedb",
  "items_count": 1000
}
```