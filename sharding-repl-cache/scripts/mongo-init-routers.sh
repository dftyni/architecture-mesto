docker compose exec -T mongos_router mongosh --port 27020 <<EOF
sh.addShard("shard1/shard1-mongodb1:27017");
sh.addShard("shard1/shard1-mongodb2:27017");
sh.addShard("shard1/shard1-mongodb3:27017");

sh.addShard("shard2/shard2-mongodb1:27017");
sh.addShard("shard2/shard2-mongodb2:27017");
sh.addShard("shard2/shard2-mongodb3:27017");

sh.enableSharding("somedb");
sh.shardCollection("somedb.helloDoc", { "name" : "hashed" } )

use somedb

for(var i = 0; i < 1000; i++) db.helloDoc.insert({age:i, name:"ly"+i})

db.helloDoc.countDocuments() 
exit();

EOF