#!/bin/bash

set -e

sh ./scripts/mongo-init-configsvr.sh
sh ./scripts/mongo-init-shard1.sh
sh ./scripts/mongo-init-shard2.sh
sleep 3
sh ./scripts/mongo-init-routers.sh