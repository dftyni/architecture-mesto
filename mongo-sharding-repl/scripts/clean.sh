#!/bin/bash

sudo docker stop configSrv
sudo docker stop shard1
sudo docker stop shard2
sudo docker stop mongos_router
sudo docker stop pymongo_api
sudo docker stop shard1a
sudo docker-compose down --volumes
sudo docker volume rm architecture-sprint-2_mongodb1_data_container
sudo docker volume rm mongo-sharding_config-data
sudo docker volume rm mongo-sharding_shard1-data
sudo docker volume rm mongo-sharding_shard2-data
sudo docker volume rm mongo-sharding_shard1a-data
sudo docker volume rm mongo-sharding_shard1b-data
sudo docker volume rm mongo-sharding_shard2a-data
sudo docker volume rm mongo-sharding_shard2b-data
sudo docker volume rm portainer_data
sudo docker system prune --volumes
sudo docker volume ls