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

### Если вы запускаете проект на локальной машине

Откройте в браузере http://localhost:8080

### Проверка шардирования

Сделайте проверку на шардах:

Для шарда 1:
```bash
 docker exec -it shard1 mongosh --port 27018
```

```
 use somedb;
 db.helloDoc.countDocuments();
 exit();
```

Для шарда 2:
```bash
docker exec -it shard2 mongosh --port 27019
```

```
use somedb;
db.helloDoc.countDocuments();
exit();
```

Сумма документов шарда 1 и шарда 2 должна быть равна 1000. (см.scripts/mongo-init.sh)