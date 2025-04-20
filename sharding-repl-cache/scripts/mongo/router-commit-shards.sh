docker compose exec -it mongos_router mongosh --port 27022 --quiet <<EOF
sh.addShard("shard1/shard1-repl1:27018");
sh.addShard("shard2/shard2-repl1:27020");

sh.enableSharding("somedb");
sh.shardCollection(
    "somedb.helloDoc", 
    { "name" : "hashed" } 
)
exit()
EOF