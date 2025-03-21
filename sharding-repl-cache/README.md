

# !!! Архитектура решения находится в документе Architecture_sprint_2_v1.drawio !!!

## Как запустить

# Запускаем mongodb и приложение в shell


docker compose up -d


# Подключаемся к серверу конфигурации и делаем инициализацию:

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
exit();


docker exec -it shard1-r1 mongosh --port 27021

> rs.initiate(
  {
    _id : "shard1",
    members: [
      { _id : 0, host : "shard1-r1:27021" },
      { _id : 1, host : "shard1-r2:27022" },
      { _id : 2, host : "shard1-r3:27023" },
    ]
  }
);

> exit();

docker exec -it shard2-r1 mongosh --port 27031

rs.initiate(
  {
    _id : "shard2",
    members: [
      { _id : 0, host : "shard2-r1:27031" },
      { _id : 1, host : "shard2-r2:27032" },
      { _id : 2, host : "shard2-r3:27033" },
    ]
  }
);

> exit();


# Инициируем роутер и наполняем базы тестовыми данными:

docker exec -it mongos_router mongosh --port 27020

> sh.addShard( "shard1/shard1-r1:27021", "shard1/shard1-r2:27022", "shard1/shard1-r3:27023");
> sh.addShard( "shard2/shard2-r1:27031", "shard2/shard2-r2:27032", "shard2/shard2-r3:27033");

> sh.enableSharding("somedb");
> sh.shardCollection("somedb.helloDoc", { "name" : "hashed" } )

> use somedb
> for(var i = 0; i < 1000; i++) db.helloDoc.insertOne({age:i, name:"ly"+i})

> db.helloDoc.countDocuments(); 
> exit();

## Как проверить

### Сделайте проверку на шардах:

docker exec -it mongos_router mongosh --port 27020
> use somedb
> db.helloDoc.getShardDistribution()
> exit();


### Если вы запускаете проект на локальной машине

Откройте в браузере http://localhost:8080

### Если вы запускаете проект на предоставленной виртуальной машине

Узнать белый ip виртуальной машины

curl --silent http://ifconfig.me

Откройте в браузере http://<ip виртуальной машины>:8080

## Доступные эндпоинты

Список доступных эндпоинтов, swagger http://<ip виртуальной машины>:8080/docs