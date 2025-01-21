sh.addShard("rs-shard-01/shard01-a:27017");
sh.addShard("rs-shard-01/shard01-b:27017");
sh.addShard("rs-shard-01/shard01-c:27017");
sh.addShard("rs-shard-02/shard02-a:27017");
sh.addShard("rs-shard-02/shard02-b:27017");
sh.addShard("rs-shard-02/shard02-c:27017");

db = db.getSiblingDB("somedb");
db.helloDoc.insertOne({ name: "test", age: 0 }); // Создание коллекции

sh.enableSharding("somedb");
db.helloDoc.createIndex({ "name": "hashed" });
sh.shardCollection("somedb.helloDoc", { "name": "hashed" });

db.helloDoc.deleteOne({ name: "test" }); // Удаляем временный документ
