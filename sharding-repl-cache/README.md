# sharding-repl-cache

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

3) Инициализируйте шарды и реплики:

```shell
docker exec -it shard1-1 mongosh --port 27018

> rs.initiate(
    {
      _id : "shard1",
      members: [
        {_id: 0, host: "shard1-1:27018"},
        {_id: 1, host: "shard1-2:27021"},
        {_id: 2, host: "shard1-3:27023"}
      ]
    }
);
> exit();

docker exec -it shard2-1 mongosh --port 27019

> rs.initiate(
    {
      _id : "shard2",
      members: [
        {_id: 0, host: "shard2-1:27019"},
        {_id: 1, host: "shard2-2:27022"},
        {_id: 2, host: "shard2-3:27024"}
      ]
    }
  );
> exit();

```

4) Инцициализируйте роутер

```shell
docker exec -it mongos_router mongosh --port 27020

> sh.addShard( "shard1/shard1-1:27018,shard1-2:27021,shard1-3:27023");
> sh.addShard( "shard2/shard2-1:27019,shard2-2:27022,shard2-3:27024");
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

docker compose exec -T shard1-1 mongosh --port 27018 --quiet <<EOF
use somedb
db.helloDoc.countDocuments()
EOF
 
 ```
Получится результат — 492 документа.

```shell

docker compose exec -T shard2-1 mongosh --port 27019 --quiet <<EOF
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

8) Для оценки скорости выполнеия запроса выполните в терминале 

```shell
time curl -X 'GET' \
'http://localhost:8080/helloDoc/users' \
-H 'accept: application/json'
```
Время ответа составит: 1.147 total

Выполните потворный вызов. Время ответа составит: 0.068 total