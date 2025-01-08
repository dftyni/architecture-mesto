# Задание 3. Репликация

# Первый вариант схемы
[task1-2.drawio]

## Запустить Docker Desktop

## Запускаем compose.yaml

```shell
docker compose up -d
```

## Заполняем mongodb данными

```shell
cd scripts
db_init.bat

```shell
docker exec -it shard1-1 mongo --quiet --port 27011
> rs.initiate({_id: "shard1", members: [ {_id: 0, host: "shard1-1:27011"}, {_id: 1, host: "shard1-2:27012"}, {_id: 2, host: "shard1-3:27013"} ]})
> exit
```

```shell
docker exec -it shard2-1 mongo --quiet --port 27021
> rs.initiate({_id: "shard2", members: [ {_id: 0, host: "shard2-1:27021"}, {_id: 1, host: "shard2-2:27022"}, {_id: 2, host: "shard2-3:27023"} ]})
> exit
```

docker exec -it router mongo --quiet --port 27020
> sh.addShard( "shard1/shard1:27018"); sh.addShard( "shard2/shard2:27019"); sh.enableSharding("somedb"); sh.shardCollection("somedb.helloDoc", { "name" : "hashed" } )
> use somedb
> for(var i = 0; i < 1000; i++) db.helloDoc.insert({age:i, name:"ly"+i})
> exit
```

## Проверяем количество записей в шардах

```shell
show_info.bat
```

## Проверяем количество записей в шардах через web
`curl -X GET http://localhost:8080/helloDoc/count -H "accept: application/json"`


## Проверяем реплики
>docker exec -it shard2-1 mongo --quiet --port 27021
shard2:PRIMARY> rs.status()