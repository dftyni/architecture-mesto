docker compose exec -T shard2 mongosh --port 27021 --quiet <<EOF
use somedb
db.helloDoc.countDocuments()
EOF