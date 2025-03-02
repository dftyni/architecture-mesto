#!/bin/bash

###
# загружаем данные в роутер
###

docker compose exec -T mongos_router mongosh --port 27020 --quiet <<EOF

use somedb

for(var i = 0; i < 1000; i++) db.helloDoc.insert({age:i, name:"ly"+i})

exit();
EOF 