#!/bin/bash
docker compose exec -T mongodb_config_server mongosh <<EOF
rs.initiate(
  {
    _id : "config_server",
       configsvr: true,
    members: [
      { _id : 0, host : "mongodb_config_server:27017" }
    ]
  }
);
exit();
EOF