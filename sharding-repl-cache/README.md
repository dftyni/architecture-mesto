# Replication steps

## Required
### Windows 
* git (for .sh scripts running)

## Main scenario
* С физического ПК `./scripts/init-cfg-server.sh`
* Выполнить `./scripts/init-shards.sh`
* Выполнить `./scripts/router-commit-shards.sh`

## Test case
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
docker compose exec -it shard1-repl2 mongosh --port 27019
use somedb;
db.helloDoc.countDocuments();
exit
```

# FAQ
* cleanup volumes -> `./scripts/clean-volumes.sh`