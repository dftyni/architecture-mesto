###
# Проверка данных на шардах
###

###
# Получится результат — 492 документа shard1
###
docker compose exec -T shard1 mongosh --port 27018 --quiet <<EOF
use somedb
db.helloDoc.countDocuments()
exit()
EOF

###
# Получится результат — 492 документа shard1-1
###
docker compose exec -T shard1-1 mongosh --port 27021 --quiet <<EOF
use somedb
db.helloDoc.countDocuments()
exit()
EOF

###
# Получится результат — 492 документа shard1-2
###
docker compose exec -T shard1-2 mongosh --port 27022 --quiet <<EOF
use somedb
db.helloDoc.countDocuments()
exit()
EOF

###
# Получится результат — 492 документа shard1-3
###
docker compose exec -T shard1-3 mongosh --port 27023 --quiet <<EOF
use somedb
db.helloDoc.countDocuments()
exit()
EOF

#################################################################################

###
# Получится результат — 508 документов shard2
###
docker compose exec -T shard2 mongosh --port 27019 --quiet <<EOF
use somedb
db.helloDoc.countDocuments()
exit()
EOF

###
# Получится результат — 508 документов shard2-1
###
docker compose exec -T shard2-1 mongosh --port 27024 --quiet <<EOF
use somedb
db.helloDoc.countDocuments()
exit()
EOF

###
# Получится результат — 508 документов shard2-2
###
docker compose exec -T shard2-2 mongosh --port 27025 --quiet <<EOF
use somedb
db.helloDoc.countDocuments()
exit()
EOF

###
# Получится результат — 508 документов shard2-3
###
docker compose exec -T shard2-3 mongosh --port 27026 --quiet <<EOF
use somedb
db.helloDoc.countDocuments()
exit()
EOF
