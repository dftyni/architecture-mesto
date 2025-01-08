# Спринт 2

В каждой из следующих папок есть README.md проекта с инструкциями, как запустить проект:

 - mongo-sharding
 - mongo-sharding-repl
 - sharding-repl-cache

Итоговая схема  в файле draw.io.

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

### In MS Windows10
```

architecture-sprint-2>docker exec -it mongodb1 mongo --quiet
> use somedb;
> for(var i = 0; i < 1000; i++) db.helloDoc.insertOne({age:i, name:"ly"+i})
> db.helloDoc.countDocuments({});
> exit

```

### Check doc count
curl -X GET http://localhost:8080/helloDoc/count -H "accept: application/json"

## Как проверить

### Если вы запускаете проект на локальной машине

Откройте в браузере http://localhost:8080

### Если вы запускаете проект на предоставленной виртуальной машине

Узнать белый ip виртуальной машины

```shell
curl --silent http://ifconfig.me
```



