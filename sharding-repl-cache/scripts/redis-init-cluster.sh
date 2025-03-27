docker compose exec -T redis_0 bash <<EOF
echo "yes" | redis-cli --cluster create 173.17.0.200:6379 173.17.0.201:6379 173.17.0.202:6379 173.17.0.203:6379 173.17.0.204:6379 173.17.0.205:6379 --cluster-replicas 1
EOF