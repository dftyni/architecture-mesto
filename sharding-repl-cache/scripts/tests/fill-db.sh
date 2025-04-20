docker compose exec -it mongos_router mongosh --port 27022 --quiet <<EOF
use somedb
for(var i = 0; i < 1500; i++) db.helloDoc.insert({age:i, name:"user"+i})

db.helloDoc.countDocuments() 
EOF