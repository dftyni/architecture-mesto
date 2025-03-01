#!/bin/bash

echo "Проверка статуса MongoDB с шардированием и репликацией..."

echo "Статус контейнеров:"
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}" | grep -E 'configSrv|shard|mongos_router|redis|pymongo_api'

echo -e "\nСтатус репликации сервера конфигурации:"
docker exec -t configSrv mongosh --port 27017 --quiet --eval "rs.status().ok" 2>/dev/null || echo "Недоступен"

echo -e "\nСтатус репликации первого шарда:"
docker exec -t shard1-1 mongosh --port 27018 --quiet --eval "rs.status().ok" 2>/dev/null || echo "Недоступен"

echo -e "\nСтатус репликации второго шарда:"
docker exec -t shard2-1 mongosh --port 27021 --quiet --eval "rs.status().ok" 2>/dev/null || echo "Недоступен"

echo -e "\nСтатус роутера:"
docker exec -t mongos_router mongosh --port 27024 --quiet --eval "db.adminCommand('ping').ok" 2>/dev/null || echo "Недоступен"

echo -e "\nСтатус шардирования:"
docker exec -t mongos_router mongosh --port 27024 --quiet --eval "sh.status()" 2>/dev/null || echo "Недоступен"

echo -e "\nКоличество документов в коллекции helloDoc:"
docker exec -t mongos_router mongosh --port 27024 --quiet --eval "use somedb; db.helloDoc.countDocuments()" 2>/dev/null || echo "Недоступен"

echo -e "\nПроверка статуса завершена!" 
