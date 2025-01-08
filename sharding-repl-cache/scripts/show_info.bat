docker compose exec -T shard1 mongo --quiet --port 27018 <show_doc_count.js
docker compose exec -T shard2 mongo --quiet --port 27019 <show_doc_count.js
