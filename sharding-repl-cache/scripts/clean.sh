#!/bin/bash

sudo docker stop configSrv
sudo docker stop shard1
sudo docker stop shard2
sudo docker stop mongos_router
sudo docker stop pymongo_api
sudo docker stop shard1a
sudo docker stop shard1b
sudo docker stop shard2a
sudo docker stop shard2b
sudo docker stop redis_1
sudo docker-compose down --volumes
sudo docker volume rm sharding-repl-cache_config-data
sudo docker volume rm sharding-repl-cache_shard1-data
sudo docker volume rm sharding-repl-cache_shard2-data
sudo docker volume rm sharding-repl-cache_shard1a-data
sudo docker volume rm sharding-repl-cache_shard1b-data
sudo docker volume rm sharding-repl-cache_shard2a-data
sudo docker volume rm sharding-repl-cache_shard2b-data
sudo docker volume rm sharding-repl-cache_redis_1_data
sudo docker system prune --volumes
sudo docker volume ls