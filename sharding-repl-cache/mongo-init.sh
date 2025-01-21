#!/bin/bash

# Пути к скриптам
CONFIG_SCRIPTS=(
  "./scripts/init-configserver.js"
)
ROUTER_SCRIPTS=(
  "./scripts/init-router.js"
)
SHARD_1_SCRIPTS=(
  "./scripts/init-shard01.js"
)
SHARD_2_SCRIPTS=(
  "./scripts/init-shard02.js"
)

# Функция для выполнения скрипта в контейнере
run_script_in_container() {
  local container_name="$1"
  local script_path="$2"

  echo ">>> Запуск $script_path в контейнере $container_name"
  docker exec -i "$container_name" mongosh --quiet < "$script_path"

  if [ $? -ne 0 ]; then
    echo "!!! Ошибка выполнения скрипта $script_path в контейнере $container_name"
    exit 1
  fi

    echo ">>> Пауза перед следующим скриптом..."
    sleep 10
}

# Запуск скриптов для конфигурационных серверов
for container in mongo-config-01; do
  for script in "${CONFIG_SCRIPTS[@]}"; do
    run_script_in_container "$container" "$script"
  done
done


# Запуск скриптов для первого шарда
#for container in shard-01-node-a shard-01-node-b shard-01-node-c; do
#  for script in "${SHARD_1_SCRIPTS[@]}"; do
#    run_script_in_container "$container" "$script"
#  done
#done
for container in shard-01-node-a; do
  for script in "${SHARD_1_SCRIPTS[@]}"; do
    run_script_in_container "$container" "$script"
  done
done

# Запуск скриптов для второго шарда
for container in shard-02-node-a; do
  for script in "${SHARD_2_SCRIPTS[@]}"; do
    run_script_in_container "$container" "$script"
  done
done


# Запуск скриптов для роутеров
#for container in router-01 router-02; do
for container in router-01; do
  for script in "${ROUTER_SCRIPTS[@]}"; do
    run_script_in_container "$container" "$script"
  done
done

# Выполнение финального действия на первом узле первого шарда
echo ">>> Выполнение финальных операций (вставка данных в базу)..."
docker compose exec -T router-01 mongosh --quiet <<EOF
use somedb
for(var i = 0; i < 1000; i++){ db.helloDoc.insertOne({age:i, name:"ly"+i})}
EOF

if [ $? -ne 0 ]; then
  echo "!!! Ошибка при выполнении финальных операций"
  exit 1
fi

echo ">>> Все операции успешно выполнены!"