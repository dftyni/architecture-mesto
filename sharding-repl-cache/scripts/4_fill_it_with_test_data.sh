###
# Наполните его тестовыми данными
###

docker compose exec -T mongos-router mongosh --port 27020 --quiet <<EOF
use somedb
for(var i = 0; i < 1000; i++) db.helloDoc.insertOne({age:i, name:"ly"+i})
db.helloDoc.countDocuments()
exit();
EOF