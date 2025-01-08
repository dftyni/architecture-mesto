docker compose exec -T configSrv mongo --quiet --port 27017 <configSrv_init.js
docker compose exec -T shard1 mongo --quiet --port 27018 <shard1_init.js
docker compose exec -T shard2 mongo --quiet --port 27019 <shard2_init.js
