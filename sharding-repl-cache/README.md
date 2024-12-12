# sharding-repl-cache
> Задание 4. Кэширование

[Схема drawio](task_3.drawio)

## Как запустить

Запускаем mongodb и приложение:
```shell
docker compose up -d
```

Подключаемся к серверу конфигурации и инициализируем его:
```shell
./scripts/1_connecting_to_and_initializing_the_configuration_server.sh
```
[1_connecting_to_and_initializing_the_configuration_server.sh](scripts/1_connecting_to_and_initializing_the_configuration_server.sh)

Инициализируем шарды и реплики:
```shell
./scripts/2_initialization_of_shards.sh
```
[2_initialization_of_shards_and_replicas.sh](scripts/2_initialization_of_shards_and_replicas.sh)

Инициализируем роутер:
```shell
./scripts/3_initialize_the_router.sh
```
[3_initialize_the_router.sh](scripts/3_initialize_the_router.sh)

По необходимости заполняем mongodb тестовыми данными
```shell
./scripts/4_fill_it_with_test_data.sh
```
[4_fill_it_with_test_data.sh](scripts/4_fill_it_with_test_data.sh)

## Как проверить

### Проверка данных на шардах
```shell
./scripts/5_data_validation_on_shards.sh
```
[5_data_validation_on_shards.sh](scripts/5_data_validation_on_shards.sh)

### Если вы запускаете проект на локальной машине

Откройте в браузере http://localhost:8080

### Если вы запускаете проект на предоставленной виртуальной машине

Узнать белый ip виртуальной машины

```shell
curl --silent http://ifconfig.me
```

Откройте в браузере http://<ip виртуальной машины>:8080

## Доступные эндпоинты

Список доступных эндпоинтов, swagger http://<ip виртуальной машины>:8080/docs