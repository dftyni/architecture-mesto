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
Инициализация шарда 1
```shell
docker compose exec -T mongoShard1Primary mongosh --port 27018 --quiet <<EOF
rs.initiate(
    {
      _id : "mongoShard1Rs",
      members: [
        {_id: 0, host: "mongoShard1Primary:27018"},
        {_id: 1, host: "mongoShard1Repl1:27019"},
        {_id: 2, host: "mongoShard1Repl2:27020"},
        {_id: 3, host: "mongoShard1Repl3:27021"}
      ]
    }
);
EOF
```
Инициализация шарда 2
```shell
docker compose exec -T mongoShard2Primary mongosh --port 27022 --quiet <<EOF
rs.initiate(
    {
      _id : "mongoShard2Rs",
      members: [
        { _id : 0, host : "mongoShard2Primary:27022" },
        { _id : 1, host : "mongoShard2Repl1:27023" },
        { _id : 2, host : "mongoShard2Repl2:27024" },
        { _id : 3, host : "mongoShard2Repl3:27025" }
      ]
    }
  );
EOF
```
Инициализация роутера, коллекции и наполнение ее данными
```shell
docker compose exec -T mongoRouter mongosh --port 27026 --quiet <<EOF
sh.addShard( "mongoShard1Rs/mongoShard1Primary:27018");
sh.addShard( "mongoShard2Rs/mongoShard2Primary:27022");
sh.enableSharding("somedb");
sh.shardCollection("somedb.helloDoc", { "name" : "hashed" } );
use somedb;
for(var i = 0; i < 1000; i++) db.helloDoc.insertOne({age:i, name:"ly"+i});
EOF
```

Сервис доступен по адресу 173.17.0.2:8080
