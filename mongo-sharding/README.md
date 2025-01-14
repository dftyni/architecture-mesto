Из текущей директории запускаем команду:
docker-compose -f compose.yaml up -d

Инициализируем configSrv
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

Инициализируем Шарду 1.
docker exec -it shard1 mongosh --port 27018
> rs.initiate(
{
_id : "shard1",
members: [
{ _id : 0, host : "shard1:27018" },
// { _id : 1, host : "shard2:27019" }
]
}
);
> exit();

Инициализируем Шарду 2.
docker exec -it shard2 mongosh --port 27019
> rs.initiate(
{
_id : "shard2",
members: [
// { _id : 0, host : "shard1:27018" },
{ _id : 1, host : "shard2:27019" }
]
}
);
> exit();
Инициализируем роутер и наполняем его даннымми:
docker exec -it mongos_router mongosh --port 27020

> sh.addShard( "shard1/shard1:27018");
> sh.addShard( "shard2/shard2:27019");

> sh.enableSharding("somedb");
> sh.shardCollection("somedb.helloDoc", { "name" : "hashed" } )

> use somedb

> for(var i = 0; i < 1000; i++) db.helloDoc.insert({age:i, name:"ly"+i})

> db.helloDoc.countDocuments()
> exit(); 

Открываем http://localhost:8080/docs
It works! Great!