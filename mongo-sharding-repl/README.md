# mongo-sharding-repl

## Проект состоит из следующих контейнеров

```
configSrv       // конфигурационный сервер
shard1-1        // реплика shard1
shard1-2        // реплика shard1
shard1-3        // реплика shard1
shard2-1        // реплика shard2
shard2-2        // реплика shard2
shard2-3        // реплика shard2
mongos_router   // роутер
mongo-express   // отобразить UI базы в браузере
pymongo_api     // апишка к базе
```

## Как запустить

Запускаем

```shell
docker compose -p mongo-sharding-repl up
```

Инициализируем configSrv 

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
> exit
```

Инициализируем реплики shard1 

```shell
docker exec -it shard1-1 mongosh --port 27021

> rs.initiate(
    {
      _id : "shard1",
      members: [
        { _id : 0, host : "shard1-1:27021" },
        { _id : 1, host : "shard1-2:27022" },
        { _id : 2, host : "shard1-3:27023" }
      ]
    }
);
> exit
```

Инициализируем реплики shard2

```shell
docker exec -it shard2-1 mongosh --port 27031

> rs.initiate(
    {
      _id : "shard2",
      members: [
        { _id : 0, host : "shard2-1:27031" },
        { _id : 1, host : "shard2-2:27032" },
        { _id : 2, host : "shard2-3:27033" }
      ]
    }
);
> exit
```

Инициализируем и добавляем шарды к mongos_router
Наполняем mongos_router тестовыми данными

```shell
docker exec -it mongos_router mongosh --port 27020

> sh.addShard( "shard1/shard1-1:27021");
> sh.addShard( "shard1/shard1-2:27022");
> sh.addShard( "shard1/shard1-3:27023");
> sh.addShard( "shard2/shard2-1:27031");
> sh.addShard( "shard2/shard2-2:27032");
> sh.addShard( "shard2/shard2-3:27033");

> sh.enableSharding("somedb");
> sh.shardCollection("somedb.helloDoc", { "name" : "hashed" } )

> use somedb

> for(var i = 0; i < 1000; i++) db.helloDoc.insertOne({age:i, name:"ly"+i})

> db.helloDoc.countDocuments() 
> exit
```


## Проверяем через pymongo_api

Проверить в браузере http://localhost:8080
Посмотреть базу http://localhost:8080/helloDoc/users

## Тушим

```shell
docker compose -p mongo-sharding-repl down -v
docker system prune -a --volumes
```