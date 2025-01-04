#!/bin/bash

# Запуск первого скрипта
./config.sh

sleep 5

# Запуск второго скрипта
./shard-1.sh

sleep 5

# Запуск третьего скрипта
./shard-2.sh

sleep 5

# Запуск четвертого скрипта
./router.sh