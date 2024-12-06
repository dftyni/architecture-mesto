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
Удаляем БД

```shell
./scripts/db-drop.sh
```

## Как проверить

### Если вы запускаете проект на локальной машине

1. Откройте в браузере http://localhost:8080/docs
2. Запросите данные о пользователе в БД `GET /helloDoc/users/<name_user>`
3. Посмотреть время ответа ```docker compose logs pymongo_api```
4. Запросить еще несколько раз  `GET /helloDoc/users/<name_user>`
5. Посмотреть время ответа ```docker compose logs pymongo_api```

Или можно создать нового пользователя
1. Создайте пользователя `POST /helloDoc/users`
2. Запросите созданного пользователя `GET /helloDoc/users/<name_user>`
3. Посмотрите логи контейнера с приложением ``` docker compose logs pymongo_api```

### Результат:
В моем случае были такие тайминги:
```0.456s``` ускорилось до ```0.0085s```

## Доступные эндпоинты

Список доступных эндпоинтов, swagger http://<ip виртуальной машины>:8080/docs