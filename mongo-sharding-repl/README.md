# pymongo-api

## Как запустить

Запускаем mongodb и приложение

```shell
docker compose up -d
```

Заполняем mongodb данными

```shell
./scripts/mongo-init.sh
```

## Как проверить

У нас 2 набора реплик:
- shard1
	+ shard1-n1
	+ shard1-n2
	+ shard1-n3
- shard2
	+ shard2-n1
	+ shard2-n2
	+ shard2-n3

Можно  провеcти проверку вручную:

Для шарда 1:
```bash
 docker exec -it shard1-n1 mongosh --port 27018
```

```
 use somedb;
 db.helloDoc.countDocuments();
 exit();
```

и т.п. (для всех шардов и реплик)

Либо запустить скрипт:
```shell
./scripts/test.sh
```