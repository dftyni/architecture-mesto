#!/bin/bash
docker compose exec -T mongodb_config_server mongosh --port 27200 <<EOF
rs.initiate(
  {
    _id : "config_server",
    configsvr: true,
    members: [
      { _id : 0, host : "mongodb_config_server:27200" }
    ]
  }
);
exit();
EOF