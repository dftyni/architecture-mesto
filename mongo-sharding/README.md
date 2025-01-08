# Задание 2. Шардирование

# Первый вариант схемы
[task1-1.drawio]

## Запустить Docker Desktop

## Запускаем compose.yaml

```shell
docker compose up -d
```

## Заполняем mongodb данными

```shell
cd scripts
db_init.bat

docker exec -it router mongo --quiet --port 27020
> sh.addShard( "shard1/shard1:27018");
> sh.addShard( "shard2/shard2:27019");
> sh.enableSharding("somedb");
> sh.shardCollection("somedb.helloDoc", { "name" : "hashed" } )
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


