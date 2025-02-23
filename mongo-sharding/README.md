# mongo sharding

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

В сообщениях выводимых предыдущим скриптом можно увидеть строки вида

> Adding documents, testing overall count

...
> [direct: mongos] somedb> 1000 

...
> Testing shard1 documents count

...
> shard1 [direct: primary] somedb> 492

...
> Testing shard2 documents count

...
> shard1 [direct: primary] somedb> 508

Так же должны отрабатывать следующие эндпоинты: 

* http://localhost:8080
* http://localhost:8080/docs

заменить localhost на адрес виртуальной машины , в случае если он отличается от localhost