export REDIS_URL="redis://redis_1:6379"

# config server
docker compose exec -T configSrv mongosh --port 27017 <<EOF
rs.initiate(
  {
    _id : "config_server",
       configsvr: true,
    members: [
      { _id : 0, host : "configSrv:27017" }
    ]
  }
)
EOF

# shard 1
docker compose exec -T shard1_1 mongosh --port 27018 <<EOF
rs.initiate(
    {
      _id : "shard1",
      members: [
        { _id : 0, host : "shard1_1:27018" },
        { _id : 1, host : "shard1_2:27016" },
        { _id : 2, host : "shard1_3:27015" }
      ]
    }
)
EOF

# shard 2
docker compose exec -T shard2_1 mongosh --port 27019 <<EOF
rs.initiate(
    {
      _id : "shard2",
      members: [
        { _id : 0, host : "shard2_1:27019" },
        { _id : 1, host : "shard2_2:27014" },
        { _id : 2, host : "shard2_3:27013" }
      ]
    }
)
EOF

# router
docker compose exec -T mongos_router mongosh --port 27020 <<EOF
sh.addShard( "shard1/shard1_1:27018")
sh.addShard( "shard2/shard2_1:27019")
sh.enableSharding("somedb")
sh.shardCollection("somedb.helloDoc", { "name" : "hashed" } );
use somedb
for(var i = 0; i < 1000; i++) db.helloDoc.insert({age:i, name:"ly"+i})
EOF

# redis
#docker compose exec -T redis_1 bash <<EOF
#echo "yes" | redis-cli create   173.17.0.21:6379
#EOF



