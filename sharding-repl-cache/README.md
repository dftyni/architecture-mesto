# pymongo-api

## Как запустить



Pекомендуется выполнить команду 
```shell
sudo docker-compose down -v && sudo docker volume prune
```
перед запуском основного скрипта.


Запускаем mongodb и приложение, заполняем mongodb данными (15000 документов), 
включаем шардинг, добавляем репликацию, включаем кеширование.

```shell
./scripts/mongo-init.sh
```

## Как проверить

### Если вы запускаете проект на локальной машине

Откройте в браузере http://localhost:8080

### Если вы запускаете проект на предоставленной виртуальной машине

Узнать белый ip виртуальной машины

```shell
curl --silent http://ifconfig.me
```

Откройте в браузере http://<ip виртуальной машины>:8080

### Проверка шардирования

Для проверки количества документов на каждом шарде необходимо дождаться окончания работы скрипта mongo-init.sh. 
информация будет выведена в терминал:

```shell
[direct: mongos] somedb> shard1ReplSet: 7442

[direct: mongos] somedb> shard2ReplSet: 7558
```

### Проверка кеширования 

```shell
time curl http://localhost:8080/helloDoc/users
time curl http://localhost:8080/helloDoc/users
```

Первый запрос - медленный. Второй - с использованием кеширования - быстрый.

## Доступные эндпоинты

Список доступных эндпоинтов, swagger http://<ip виртуальной машины>:8080/docs


# LINK

https://drive.google.com/file/d/10gq7yUqj-rN6duAvYXkyZTcw_F_FRLZY/view?usp=drive_link

