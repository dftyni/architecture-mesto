#!/bin/bash

until /usr/bin/mongosh --port 27017 --quiet --eval 'db.getMongo()'; do
    sleep 1
done

sleep 1
# инициализация документа и заполнение значениями
/usr/bin/mongosh --port 27017 <<EOF
use somedb;
db.createCollection("helloDoc");
sh.enableSharding("somedb");
sh.shardCollection("somedb.helloDoc", { "name" : "hashed" } );

for(var i = 0; i < 1000; i++) db.helloDoc.insertOne({age:i, name:"ly"+i})
EOF
