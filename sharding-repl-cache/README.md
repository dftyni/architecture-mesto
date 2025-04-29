# pymongo-api

## Схема

https://drive.google.com/file/d/19U6xUDyqaub2ZnotnwusWme2PI4mYlWR/view?usp=sharing

## Как запустить

Запускаем mongodb и приложение

```shell
docker compose up -d
```

Настраиваем configSrv

```
docker exec -it configSrv mongosh --port 27017

rs.initiate(
  {
    _id : "config_server",
       configsvr: true,
    members: [
      { _id : 0, host : "configSrv:27017" }
    ]
  }
)

exit
```

Первый шард

```
docker exec -it shard1a mongosh --port 27018

rs.initiate(
    {
      _id : "shard1",
      members: [
        { _id : 0, host : "shard1a:27018" },
        { _id : 1, host : "shard1b:27018" },
        { _id : 2, host : "shard1c:27018" }
      ]
    }
)

exit
```

Второй шард

```
docker exec -it shard2a mongosh --port 27019

rs.initiate(
    {
      _id : "shard2",
      members: [
        { _id : 0, host : "shard2a:27019" },
        { _id : 1, host : "shard2b:27019" },
        { _id : 2, host : "shard2c:27019" }
      ]
    }
  )

exit
```

И собственно роутер

```
docker exec -it mongos_router mongosh --port 27020

sh.addShard( "shard1/shard1a:27018,shard1b:27018,shard1c:27018");
sh.addShard( "shard2/shard2a:27019,shard2b:27019,shard2c:27019");

sh.enableSharding("somedb");
sh.shardCollection("somedb.helloDoc", { "name" : "hashed" } )
```

Наполнить данными можно и через скрипт, но мне оказалось удобнее через консоль

```
use somedb
for(var i = 0; i < 1000; i++) db.helloDoc.insert({age:i, name:"ly"+i})

exit
```
