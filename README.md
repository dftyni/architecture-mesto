# pymongo-api

## Как запустить

Переходим в папку sharding-repl-cache

Запускаем mongodb и приложение

```shell
docker compose up -d
```

Подключаемся к серверу кофигурации и делаем инициализацию

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

Инициализируем шарды и настраиваем репликацию:
```shell
docker exec -it shard1_1 mongosh --port 27018
> rs.initiate({_id: "shard1", members: [
{_id: 0, host: "shard1_1:27018"},
{_id: 1, host: "shard1_2:27019"},
{_id: 2, host: "shard1_3:27021"}
]});
> exit();
```

```shell
docker exec -it shard2_1 mongosh --port 27022
> rs.initiate({_id: "shard2", members: [
{_id: 0, host: "shard2_1:27022"},
{_id: 1, host: "shard2_2:27023"},
{_id: 2, host: "shard2_3:27024"}
]});
> exit();
```

Инцициализируйте роутер и наполняем его тестовыми данными:
```shell
docker exec -it mongos_router mongosh --port 27020
> sh.addShard( "shard1/shard1_1:27018,shard1_2:27019,shard1_3:27021");
> sh.addShard( "shard2/shard2_1:27022,shard2_2:27023,shard2_3:27024");
> sh.enableSharding("somedb");
> sh.shardCollection("somedb.helloDoc", { "name" : "hashed" } )
> use somedb
> for(var i = 0; i < 1000; i++) db.helloDoc.insert({age:i, name:"ly"+i})
> db.helloDoc.countDocuments() 
> exit(); 
```

## Как проверить

### Проверка на шардах
```shell
docker exec -it shard1_1 mongosh --port 27018
> use somedb;
> db.helloDoc.countDocuments();
> exit(); 
```
Должно получиться 492 документа

```shell
docker exec -it shard2_1 mongosh --port 27022
> use somedb;
> db.helloDoc.countDocuments();
> exit(); 
```
Должно получиться 508 документов

### Запуск проекта на локальной машине

Откройте в браузере http://localhost:8080

### Если вы запускаете проект на предоставленной виртуальной машине

Узнать белый ip виртуальной машины

```shell
curl --silent http://ifconfig.me
```

Откройте в браузере http://<ip виртуальной машины>:8080

## Проверка кэширования

Сделайте вызов http://localhost:8080/helloDoc/users или http://<ip виртуальной машины>:8080/helloDoc/users
Повторите получение данных http://localhost:8080/helloDoc/users или http://<ip виртуальной машины>:8080/helloDoc/users
Повторный вызов должен выполняться существенно быстрее
