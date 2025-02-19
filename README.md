# pymongo-api

## запуск

1. Запускаем mongodb и приложение

```shell
docker compose up -d
```

2. Заполняем mongodb данными и выполняем проверку заполнения шардов документами

```shell
./scripts/mongo-init.sh
```


3. Проверка работоспособности приложения:
Откройте в браузере http://localhost:8080

## Доступные эндпоинты

Список доступных эндпоинтов, swagger http://localhost:8080/docs
