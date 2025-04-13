const db = db.getSiblingDB("somedb");

db.helloDoc.createIndex({ user_id: 1 });

for (let i = 1; i <= 1002; i++) {
  db.helloDoc.insertOne({ user_id: i, name: "User " + i });
}
