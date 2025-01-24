# Как запустить

Шаг 1: Запуск контейнеров

docker compose up -d

Ша 2: Запуск и инициализация сервера конфигурации и шардов

./scripts/init-configserver.sh

./scripts/init-shards.sh

Шаг 3: Инициализация роутера и наполнение данными

./scripts/init-router.sh

Шаг 4: Проверка счетчика в каждом из шардов

./scripts/shard1_count.sh

./scripts/shard2_count.sh

Схема Draw.io:
https://drive.google.com/file/d/1VRZnZL-LnHt0midOo5fjBZV4KuQfFpyb/view?usp=sharing

либо файл "Схемы_Спринт_2" в корневой папке