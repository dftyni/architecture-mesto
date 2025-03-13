#!/bin/sh

exec /usr/local/bin/mongod-init-replicas.sh &
exec /usr/local/bin/docker-entrypoint.sh "$@"
