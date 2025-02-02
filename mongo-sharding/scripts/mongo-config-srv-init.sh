#!/bin/bash

###
# Инициализируем сервер конфигурации
###

docker exec -it configSrv mongosh --port 27019 --quiet <<EOF
rs.initiate(
  {
    _id : "config_server",
       configsvr: true,
    members: [
      { _id : 0, host : "configSrv:27019" }
    ]
  }
);
exit();
EOF 

