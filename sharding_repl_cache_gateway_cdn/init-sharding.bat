@echo off
chcp 65001 >nul


rem === Шаг 1. Инициализация реплики конфиг-сервера ===
docker exec configsvr mongosh --quiet --eval ^
"rs.initiate({_id: 'cfgRS', configsvr: true, members: [{ _id: 0, host: 'configsvr:27017' }]})"
timeout /t 5 >nul

rem === Шаг 2. Инициализация реплик shard1RS ===
docker exec shard1-a mongosh --port 27018 --quiet --eval ^
"rs.initiate({_id: 'shard1RS', members: [ ^
  { _id: 0, host: 'shard1-a:27018' }, ^
  { _id: 1, host: 'shard1-b:27019' }, ^
  { _id: 2, host: 'shard1-c:27020' } ]})"
timeout /t 5 >nul

rem === Шаг 3. Инициализация реплик shard2RS ===
docker exec shard2-a mongosh --port 27021 --quiet --eval ^
"rs.initiate({_id: 'shard2RS', members: [ ^
  { _id: 0, host: 'shard2-a:27021' }, ^
  { _id: 1, host: 'shard2-b:27022' }, ^
  { _id: 2, host: 'shard2-c:27023' } ]})"
timeout /t 5 >nul

rem === Шаг 4. Подключаем шарды, настраиваем коллекцию и вставляем данные ===
docker exec mongos mongosh --quiet --eval ^
"sh.addShard('shard1RS/shard1-a:27018,shard1-b:27019,shard1-c:27020'); ^
sh.addShard('shard2RS/shard2-a:27021,shard2-b:27022,shard2-c:27023'); ^
sh.enableSharding('somedb'); ^
sh.shardCollection('somedb.helloDoc', { user_id: 1 }); ^
db = db.getSiblingDB('somedb'); ^
db.helloDoc.createIndex({ user_id: 1 }); ^
sh.splitAt('somedb.helloDoc', { user_id: 500 });"

rem === Шаг 5. Вставка данных из файла ===
docker cp init-data.js mongos:/init-data.js
docker exec mongos mongosh --quiet --file /init-data.js

echo.
echo Готово. Репликация и шардинг настроены, данные вставлены.
pause
