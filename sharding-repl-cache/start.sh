#!/bin/bash

echo "Запускаем MongoDB с шардированием и репликацией..."

echo "Запускаем контейнеры..."
docker compose up -d

echo "Ожидаем готовности всех контейнеров..."

# Функция для проверки доступности MongoDB
check_mongo_availability() {
  local container=$1
  local port=$2
  local max_attempts=30
  local attempt=1

  echo "Проверяем доступность $container на порту $port..."
  
  while [ $attempt -le $max_attempts ]; do
    if docker exec -t $container mongosh --port $port --eval "db.adminCommand('ping')" &>/dev/null; then
      echo "$container на порту $port готов!"
      return 0
    fi
    
    echo "Попытка $attempt/$max_attempts: $container еще не готов. Ожидаем..."
    sleep 5
    ((attempt++))
  done
  
  echo "Ошибка: $container не стал доступен после $max_attempts попыток."
  return 1
}

check_mongo_availability "configSrv" "27017" || exit 1
check_mongo_availability "shard1-1" "27018" || exit 1
check_mongo_availability "shard2-1" "27021" || exit 1

echo "Запускаем скрипт инициализации..."
./init-mongodb.sh

echo "MongoDB с шардированием и репликацией успешно запущена!"

echo "Проверка приложения:"
curl -X 'GET' 'http://localhost:8080/' -H 'accept: application/json' | jq .

echo "Проверка количества документов в коллекции helloDoc:"
curl -X 'GET' 'http://localhost:8080/helloDoc/count' -H 'accept: application/json' | jq .

echo "Запрос данных из коллекции helloDoc. Временя выполнения запроса:"
curl -w "@curl-time" -o /dev/null -s "http://localhost:8080/helloDoc/users"

echo "Повторный запрос данных из коллекции helloDoc для проверки кэширования. Временя выполнения запроса:"
curl -w "@curl-time" -o /dev/null -s "http://localhost:8080/helloDoc/users"
