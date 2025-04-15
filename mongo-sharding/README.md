# Sharding steps

## Required
### Windows 
* git
### Linux
* not an arch mood

## Prerequisites
* В компоуз на основе image'ей добавить:
    * configSrv
    * mongos_router
    * shard1
    * shard2
* Объединить в общую сеть, все компоненты

## Main scenario
* С физического ПК `./scripts/init-cfg-server.sh`
* Выполнить `./scripts/init-shards.sh`
* Выполнить `./scripts/router-commit-shards.sh`

## Test case
> Как я понял, заполнять БД самим не надо, поэтому отдельно на всякий
* Заполнение БД ~ скрипт в `./scripts/tests/fill-db.sh`
```bash
docker exec -it mongos_router mongosh --port 27020

use somedb
for(var i = 0; i < 1500; i++) db.helloDoc.insert({age:i, name:"user"+i})

db.helloDoc.countDocuments() 
exit()
```

* Проверка, например, первого шарда:
```bash
docker exec -it shard1 mongosh --port 27018
use somedb;
db.helloDoc.countDocuments();
exit(); 
```

# FAQ
* `MongoServerError[AlreadyInitialized]: already initialized`:
```bash
# Also it's a clean-volumes.sh
docker volume rm mongo-sharding_shard1-data
docker volume rm mongo-sharding_shard2-data

# check
docker volume ls
```