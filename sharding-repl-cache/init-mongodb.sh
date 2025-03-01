#!/bin/bash

# Функция для выполнения команды MongoDB с проверкой результата
execute_mongo_command() {
  local container=$1
  local port=$2
  local description=$3
  local command=$4
  
  echo "Выполняем $description на $container:$port..."
  
  # Выполняем команду и сохраняем результат
  result=$(docker exec -t $container mongosh --port $port --quiet --eval "$command")
  
  # Проверяем результат
  if echo "$result" | grep -q "ok" && ! echo "$result" | grep -q "NotYetInitialized"; then
    echo "$description успешно выполнено"
    return 0
  else
    echo "Ошибка при выполнении $description: $result"
    return 1
  fi
}

run_mongo_command() {
  local container=$1
  local port=$2
  local description=$3
  local commands=$4
  
  echo "Выполняем $description на $container:$port..."
  
  # Создаем временный файл для команд
  local temp_file=$(mktemp)
  echo "$commands" > "$temp_file"
  
  # Выполняем команду
  cat "$temp_file" | docker exec -i $container mongosh --port $port
  local result=$?
  
  # Удаляем временный файл
  rm "$temp_file"
  
  if [ $result -eq 0 ]; then
    echo "$description успешно выполнено"
    return 0
  else
    echo "Ошибка при выполнении $description"
    return 1
  fi
}

echo "Начинаем настройку MongoDB шардирования и репликации..."

echo "Инициализация сервера конфигурации..."
run_mongo_command "configSrv" "27017" "инициализация сервера конфигурации" "
rs.initiate(
  {
    _id : 'config_server',
    configsvr: true,
    members: [
      { _id : 0, host : 'configSrv:27017' }
    ]
  }
);
"

# Самое долгое время ожидания инициализации сервера конфигурации :(

echo "Проверка статуса сервера конфигурации..."
for i in {1..10}; do
  status=$(docker exec -t configSrv mongosh --port 27017 --quiet --eval "try { rs.status().ok } catch(e) { print('Error: ' + e.message); 0 }")
  echo "Статус репликации: $status"
  
  if [[ "$status" == *"1"* ]]; then
    echo "Сервер конфигурации успешно инициализирован!"
    break
  fi
  
  if [ $i -eq 10 ]; then
    echo "Не удалось инициализировать сервер конфигурации после 10 попыток."
    exit 1
  fi
  
  echo "Ожидаем инициализации сервера конфигурации (попытка $i/10)..."
  sleep 10
done

echo "Инициализация первого шарда..."
run_mongo_command "shard1-1" "27018" "инициализация первого шарда" "
rs.initiate(
  {
    _id : 'shard1',
    members: [
      { _id : 0, host : 'shard1-1:27018' },
      { _id : 1, host : 'shard1-2:27019' },
      { _id : 2, host : 'shard1-3:27020' }
    ]
  }
);
"

echo "Ожидаем инициализации первого шарда..."
sleep 10

# Инициализация второго шарда
echo "Инициализация второго шарда..."
run_mongo_command "shard2-1" "27021" "инициализация второго шарда" "
rs.initiate(
  {
    _id : 'shard2',
    members: [
      { _id : 0, host : 'shard2-1:27021' },
      { _id : 1, host : 'shard2-2:27022' },
      { _id : 2, host : 'shard2-3:27023' }
    ]
  }
);
"

echo "Ожидаем инициализации второго шарда..."
sleep 10

echo "Инициализация роутера и добавление шардов..."
run_mongo_command "mongos_router" "27024" "инициализация роутера и добавление шардов" "
sh.addShard('shard1/shard1-1:27018');
sh.addShard('shard2/shard2-1:27021');

sh.enableSharding('somedb');
sh.shardCollection('somedb.helloDoc', { 'name' : 'hashed' });
"

echo "Ожидаем готовности роутера после добавления шардов..."
sleep 10

echo "Заполнение базы данных тестовыми данными..."
run_mongo_command "mongos_router" "27024" "заполнение базы данных тестовыми данными" "
use somedb;
for(var i = 0; i < 1000; i++) db.helloDoc.insert({age:i, name:'ly'+i});
db.helloDoc.countDocuments();
"

echo "Ожидаем распределения данных по шардам..."
sleep 5

echo "Проверка распределения данных по шардам..."
run_mongo_command "mongos_router" "27024" "проверка распределения данных по шардам" "
use somedb;
db.helloDoc.getShardDistribution();
"

echo "Настройка MongoDB шардирования и репликации завершена!"
