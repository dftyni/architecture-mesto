#!/bin/sh

if [ "$DO_INIT_REPSET" = true ] ; then
    until /usr/bin/mongosh --port 27017 --quiet --eval 'db.getMongo()'; do
        sleep 1
    done

    # инициализация реплик
    /usr/bin/mongosh --port 27017 <<EOF
        rs.initiate({_id: "${REPSET_NAME}", members: [
            {_id: 0, host: "${REPSET_NAME}-replica0:27017"}
        ], settings: {electionTimeoutMillis: 2000}});
EOF
fi
