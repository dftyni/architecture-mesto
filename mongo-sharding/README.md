# mongo-sharding

## Проект состоит из следующих контейнеров

```
configSrv       // конфигурационный сервер
shard1
shard2
mongos_router   // роутер
mongo-express   // отобразить UI базы в браузере
pymongo_api     // апишка к базе
```

## Как запустить

Запускаем

```shell
docker compose -p mongo-sharding up
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

Инициализируем shard1 

```shell
docker exec -it shard1 mongosh --port 27018

> rs.initiate(
    {
      _id : "shard1",
      members: [
        { _id : 0, host : "shard1:27018" },
      ]
    }
);
> exit
```

Инициализируем shard2

```shell
docker exec -it shard2 mongosh --port 27019

> rs.initiate(
    {
      _id : "shard2",
      members: [
        { _id : 1, host : "shard2:27019" }
      ]
    }
  );
> exit
```

Инициализируем и добавляем шарды к mongos_router
Наполняем mongos_router тестовыми данными

```shell
docker exec -it mongos_router mongosh --port 27020

> sh.addShard( "shard1/shard1:27018");
> sh.addShard( "shard2/shard2:27019");

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
docker compose -p mongo-sharding down -v
docker system prune -a --volumes
```