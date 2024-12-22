# pymongo-api

## Как запустить

Открываем директорию с финальным решением

```shell
cd sharding-repl-cache
```

Запускаем все приложение через docker compose в качестве службы

```shell
docker compose up -d
```

После запуска приложения выполняем скрипт run.sh(если windows то можно использовать sh от git for windows). Этот скрипт наполнит монго данными. Скрипт запускаем через какое то время после запуска приложения, так как приложение разворачивает контейнеры и настраивает сети, оно не сразу работоспособно после выполнения.

```shell
./scripts/run.sh
```

## Как проверить

Открываем в браузере http://localhost:8080, проверяем что страница загрузилась.  Кэш можно проверить по ссылке 
http://localhost:8080/helloDoc/users


## Ссылка на схему

https://viewer.diagrams.net/?tags=%7B%7D&lightbox=1&highlight=0000ff&edit=_blank&layers=1&nav=1&title=sprint2_Final.drawio#Uhttps%3A%2F%2Fdrive.google.com%2Fuc%3Fid%3D1hvTV5GBVIzrimu-Wb7hvXccudfv9Jim5%26export%3Ddownload