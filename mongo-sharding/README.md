# mongo-sharding

## Запуск

```shell
cd mongo-sharding
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
1. В файл compose.yaml добавлены
   1. конфигурационный сервер
   2. роутер
   3. шард 1
   4. шард 2
   5. изменены настройки сервиса pymongo_api так, чтобы он работал с роутером

2. Написан скрипт инициализации шардирования для монго. Я заметил, что роутер не всегда сразу доступен, поэтому дополнил скрипт ожиданием роутера, пингуя его (healtcheck).





