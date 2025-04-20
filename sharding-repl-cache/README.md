# Caching steps

## Required
### Windows 
* git (for `.sh` scripts running)

## Main scenario
* Добавить redis сервис в docker-compose
* Развернуть его в single-node режиме (пока что)
* Указать для pymongo_api `REDIS_URL`
* Выполнить (с хоста): `./scripts/start.sh`

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

# Caching log:
```bash
2025-04-20 21:25:07 {"asctime": "2025-04-20 18:25:07,342", "process": 1, "levelname": "INFO", "X-API-REQUEST-ID": "0921dc35-d74e-4d26-a951-a9fcb0664606", "request": {"method": "GET", "path": "/helloDoc/users", "ip": "173.19.0.1"}, "response": {"status": "successful", "status_code": 200, "time_taken": "1.0224s"}, "taskName": "Task-18"}

2025-04-20 21:25:40 {"asctime": "2025-04-20 18:25:40,090", "process": 1, "levelname": "INFO", "X-API-REQUEST-ID": "b1d45cf9-78f4-45e0-916f-b39af43231a7", "request": {"method": "GET", "path": "/helloDoc/users", "ip": "173.19.0.1"}, "response": {"status": "successful", "status_code": 200, "time_taken": "0.0039s"}, "taskName": "Task-23"}
```