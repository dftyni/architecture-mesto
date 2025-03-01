#!/bin/bash

echo "Останавливаем MongoDB с шардированием и репликацией..."

echo "Останавливаем и удаляем контейнеры..."
docker compose down -v

echo "Удаляем все оставшиеся тома..."
docker volume ls | grep "mongo-sharding-repl" | awk '{print $2}' | xargs -r docker volume rm

echo "Удаляем все оставшиеся сети..."
docker network ls | grep "mongo-sharding-repl" | awk '{print $1}' | xargs -r docker network rm

echo "MongoDB с шардированием и репликацией успешно остановлена!" 
