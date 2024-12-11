###
# Проверка данных на шардах
###

###
# Получится результат — 492 документа
###
docker compose exec -T shard1 mongosh --port 27018 --quiet <<EOF
use somedb
db.helloDoc.countDocuments()
exit()
EOF

###
# Получится результат — 508 документов
###
docker compose exec -T shard2 mongosh --port 27019 --quiet <<EOF
use somedb
db.helloDoc.countDocuments()
exit()
EOF
