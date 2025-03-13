#!/bin/bash

until /usr/bin/mongosh --quiet --eval 'db.getMongo()'; do
    sleep 1
done

sleep 1

# разбить URLs шардов по разделителю ';'
IFS=';' read -r -a array <<< "$SHARD_LIST"

#  добавить шарды в кластер
for shard in "${array[@]}"; do
    /usr/bin/mongosh --port 27017 <<EOF
        sh.addShard("${shard}");
EOF
done
