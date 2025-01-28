### Запускаем приложение 

```shell
docker compose up -d

### Инициализируем config server

```shell
./scripts/01-mongo-config-srv-init.sh

### Инициализируем шарды и реплики

```shell
./scripts/02-mongo-shards-init.sh

### Инициализируем роутер и шардинг бд

```shell
./scripts/03-mongo-router-init.sh 

### Заполняем базу данными

```shell
./scripts/04-mongo-init.sh


### Проверяем количество данных в шардах

```shell
./scripts/05-mongo-check-shards.sh 

### Проверяем статус и количество данных в репликах

```shell
./scripts/06-mongo-check-replicas.sh 

### Проверяем работу кэша
```shell
./scripts/07-mongo-check-cashe.sh 

### Если вы запускаете проект на локальной машине

http://localhost:8080