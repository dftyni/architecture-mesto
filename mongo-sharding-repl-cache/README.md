# mongo-sharding-repl

## Запуск

```shell
cd mongo-sharding-repl-cache
```
```shell
docker compose build
```
```shell
docker compose down --volumes && docker compose up -d
```
```shell
./scripts/mongo-init.sh
```

## Что было сделано:
Заметил, что статус реплики в самом приложении не выводится, а даже если бы и выводился, то указал бы на то, что реплики нет, потому что у роутера и правда нет реплики.

Чтобы проверить реплики, можно выполнить команды:
```shell
docker compose exec -T shard1 mongosh --port 27018 <<EOF
rs.status();
```

```shell
docker compose exec -T shard2 mongosh --port 27019 <<EOF
rs.status();
```
В каждом шарде будет 1 master (PRIMARY) и 2 slave (SECONDARY).

В задании было сказано, что нужно 3 реплики, но я подумал, что это в сумме. При желании можно добавить еще один slave

1. В файл compose.yaml добавлены
   1. конфигурационный сервер
   2. роутер
   3. шард 1
      1. реплика 1 для шарда 1
      2. реплика 2 для шарда 2
   4. шард 2
      1. реплика 1 для шарда 2
      1. реплика 2 для шарда 2
   5. изменены настройки сервиса pymongo_api так, чтобы он работал с роутером
2. Добавлен конфиг для редиса ./redis/redis.conf
3. Написан скрипт инициализации шардирования с репликацией и кешированием для монго.





