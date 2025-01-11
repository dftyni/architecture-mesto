#!/bin/bash

docker stop configSrv
docker stop shard1
docker stop shard2
docker stop mongos_router
docker stop pymongo_api
docker stop shard1a
docker-compose down --volumes
docker volume rm architecture-sprint-2_mongodb1_data_container
docker volume rm mongo-sharding_config-data
docker volume rm mongo-sharding_shard1-data
docker volume rm mongo-sharding_shard2-data
docker volume rm mongo-sharding_shard1a-data
docker volume rm mongo-sharding_shard1b-data
docker volume rm mongo-sharding_shard2a-data
docker volume rm mongo-sharding_shard2b-data
docker volume rm portainer_data
docker volume rm redis_1_data
docker system prune --volumes
docker volume ls