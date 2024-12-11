###
# Инициализация роутера
###

docker compose exec -T mongos-router mongosh --port 27020 --quiet <<EOF
sh.addShard( "shard1/shard1:27018")
sh.addShard( "shard1/shard1-1:27021")
sh.addShard( "shard1/shard1-2:27022")
sh.addShard( "shard1/shard1-3:27023")
sh.addShard( "shard2/shard2:27019")
sh.addShard( "shard2/shard2-1:27024")
sh.addShard( "shard2/shard2-2:27025")
sh.addShard( "shard2/shard2-3:27026")
sh.enableSharding("somedb")
sh.shardCollection("somedb.helloDoc", { "name" : "hashed" } )
EOF