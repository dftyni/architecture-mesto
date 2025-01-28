### Запускаем приложение 

```shell
docker compose up -d

### Инициализируем config server

```shell
./scripts/01-mongo-config-srv-init.sh

### Инициализируем шарды 

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