# pymongo-api

## Как запустить

Запуск сервисов
```shell
docker compose up -d
```
Инициализация сервера конфигурации
```shell
docker compose exec -T mongoConfigSrv mongosh --port 27017 --quiet <<EOF
rs.initiate(
  {
    _id : "mongoConfigSrv",
    configsvr: true,
    members: [
      { _id : 0, host : "mongoConfigSrv:27017" }
    ]
  }
);
EOF
```
Инициализация шарда
```shell
docker compose exec -T mongoShard1 mongosh --port 27018 --quiet <<EOF
rs.initiate(
    {
      _id : "mongoShard1",
      members: [
        { _id : 0, host : "mongoShard1:27018" }
      ]
    }
);
EOF
```
Инициализация шарда
```shell
docker compose exec -T mongoShard2 mongosh --port 27019 --quiet <<EOF
rs.initiate(
    {
      _id : "mongoShard2",
      members: [
        { _id : 1, host : "mongoShard2:27019" }
      ]
    }
  );
EOF
```
Инициализация роутера, коллекции и наполнение ее данными
```shell
docker compose exec -T mongoRouter mongosh --port 27020 --quiet <<EOF
sh.addShard( "mongoShard1/mongoShard1:27018");
sh.addShard( "mongoShard2/mongoShard2:27019");
sh.enableSharding("somedb");
sh.shardCollection("somedb.helloDoc", { "name" : "hashed" } );
use somedb;
for(var i = 0; i < 1000; i++) db.helloDoc.insertOne({age:i, name:"ly"+i});
EOF
```

Сервис доуступен по адресу 173.17.0.2:8080
