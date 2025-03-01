#!/bin/bash

###
#  смотрим, сколько документов на первом шарде
###

docker compose exec -T shard1 mongosh --port 27018 --quiet <<EOF
use somedb;
db.helloDoc.countDocuments();
exit();
EOF 