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

Открыть в браузере http://localhost:8080, убедиться в правильности конфигурации и количестве записей в БД

заменить localhost на адрес виртуальной машины , в случае если он отличается от localhost