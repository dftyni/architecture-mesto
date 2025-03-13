#!/bin/sh

exec /usr/local/bin/mongos-init-shards.sh &
exec /usr/local/bin/mongos-filling-db.sh &

exec /usr/local/bin/docker-entrypoint.sh "$@"

