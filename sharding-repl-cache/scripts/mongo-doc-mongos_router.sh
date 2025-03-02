#!/bin/bash

###
# проверяем, наличие данных в роутер
###

docker compose exec -T mongos_router mongosh --port 27020 --quiet <<EOF
use somedb
db.helloDoc.countDocuments()
exit();
EOF 